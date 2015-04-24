/****************************************************************************
 *  Copyright (c) 2015 Anthony Vital <anthony.vital@gmail.com>              *
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

#ifndef ACCOUNT_H
#define ACCOUNT_H

#include <QObject>
#include <QNetworkAccessManager>

class Account : public QObject
{
    Q_OBJECT

public:
    Q_PROPERTY(QString feed READ feed NOTIFY feedChanged)

    Q_INVOKABLE void getFeed();
    
    explicit Account(QObject *parent = 0);
    ~Account();

    QString feed() const {return m_feed;}

Q_SIGNALS:
    void feedChanged();

private Q_SLOTS:
    void newData();

private:
    QByteArray requestToken();

    QNetworkAccessManager m_manager;
    QString m_feed;
};

#endif
