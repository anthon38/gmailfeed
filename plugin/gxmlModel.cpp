/****************************************************************************
 *  Copyright (c) 2024 Anthony Vital <anthony.vital@gmail.com>              *
 *                                                                          *
 *  This file is part of Gmail Feed.                                        *
 *                                                                          *
 *  Gmail Feed is free software: you can redistribute it and/or modify      *
 *  it under the terms of the GNU General Public License as published by    *
 *  the Free Software Foundation, either version 3 of the License, or       *
 *  (at your option) any later version.                                     *
 *                                                                          *
 *  Gmail Feed is distributed in the hope that it will be useful,           *
 *  but WITHOUT ANY WARRANTY; without even the implied warranty of          *
 *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the           *
 *  GNU General Public License for more details.                            *
 *                                                                          *
 *  You should have received a copy of the GNU General Public License       *
 *  along with Gmail Feed.  If not, see <http://www.gnu.org/licenses/>.     *
 ****************************************************************************/

#include "gxmlModel.h"

#include <QXmlStreamReader>
#include <QtConcurrent>

GxmlModel::GxmlModel(QObject *parent)
    : QAbstractListModel(parent)
    , m_status(Status::Null)
    , m_fullcount(0)
{
    connect(&m_watcher, &QFutureWatcher<Data>::finished, this, &GxmlModel::xmlParsed);
}

GxmlModel::~GxmlModel()
{
}

QHash<int, QByteArray> GxmlModel::roleNames() const
{
    QHash<int, QByteArray> roles;
    roles[AuthorRole] = "author";
    roles[TitleRole] = "title";
    roles[LinkRole] = "link";
    return roles;
}


int GxmlModel::rowCount(const QModelIndex & parent) const
{
    Q_UNUSED(parent)
    return m_data.size();
}

QVariant GxmlModel::data(const QModelIndex & index, int role) const
{
    if (!index.isValid()) {
        return QVariant();
    }

    if (index.row() >= m_data.size() || index.row() < 0) {
        return QVariant();
    }

    switch (role) {
        case AuthorRole:
            return m_data.at(index.row())["author"];
        case TitleRole:
            return m_data.at(index.row())["title"];
        case LinkRole:
            return m_data.at(index.row())["link"];
        case IdRole:
            return m_data.at(index.row())["id"];
        default:
            return QVariant();
    }
}

void GxmlModel::setXml(QString xml)
{
    if (m_status != Status::Ready) {
        m_status = Status::Loading;
        Q_EMIT(statusChanged());
    }
    QFuture<GMailData> future = QtConcurrent::run(&GxmlModel::parseXml, this, xml);
    m_watcher.setFuture(future);
}

GMailData GxmlModel::parseXml(QString xml)
{
    bool parsingMessage = false;
    bool parsingAuthor = false;
    int fullcount = -1;
    QString title;
    QString author;
    QString link;
    QString id;
    QXmlStreamReader reader(xml.toUtf8());
    if (reader.hasError()) {
        m_errorString = reader.errorString();
        m_status = Status::Error;
        Q_EMIT(statusChanged());
        return GMailData();
    }

    QList<QString> oldData;
    Q_FOREACH(auto item, m_data) {
        oldData.append(item["id"]);
    }
    int newMessagesCount = 0;
    QMap<QString, QString> firstNewMessage;

    Data newData;
    while (!reader.atEnd()) {
        if (reader.isStartElement()) {
            if (reader.name() == QLatin1String("entry")) {
                parsingMessage = true;
            } else if (reader.name() == QLatin1String("fullcount")) {
                fullcount = reader.readElementText().toInt();
            } else if (parsingMessage && reader.name() == QLatin1String("author")) {
                parsingAuthor = true;
            } else if (parsingAuthor && reader.name() == QLatin1String("name")) {
                author = reader.readElementText();
            } else if (parsingMessage && reader.name() == QLatin1String("title")) {
                title = reader.readElementText();
            } else if (parsingMessage && reader.name() == QLatin1String("link")) {
                link = reader.attributes().value("href").toString();
            } else if (parsingMessage && reader.name() == QLatin1String("id")) {
                id = reader.readElementText();
            }
        } else if (reader.isEndElement()) {
            if (reader.name() == QLatin1String("name")) {
                parsingAuthor = false;
            } else if (reader.name() == QLatin1String("entry")) {
                parsingMessage = false;
                QMap<QString, QString> item;
                item["author"] = author;
                item["title"] = title;
                item["link"] = link;
                item["id"] = id;
                newData.append(item);
                if (!oldData.contains(id)) {
                    if (newMessagesCount == 0) {
                       firstNewMessage = item;
                    }
                    newMessagesCount++;
                }
            }
        }
        reader.readNext();
    }

    if (newMessagesCount == 1) {
        Q_EMIT(newMessage(firstNewMessage["author"], firstNewMessage["title"]));
    } else if (newMessagesCount > 1) {
        Q_EMIT(newMessages(newMessagesCount));
    }

    m_xml = xml;
    Q_EMIT(xmlChanged());

    GMailData result;
    result.data = newData;
    result.fullCount = fullcount > -1 ? fullcount : newData.count();
    result.isValid = true;

    return result;
}

void GxmlModel::xmlParsed()
{
    GMailData result = m_watcher.result();
    if (result.isValid) {
        beginResetModel();
        m_data = result.data;
        endResetModel();

        Q_EMIT(countChanged());

        m_fullcount = result.fullCount;
        Q_EMIT(fullcountChanged());

        if (m_status != Status::Error) {
            m_status = Status::Ready;
            Q_EMIT(statusChanged());
        }
    }
}
