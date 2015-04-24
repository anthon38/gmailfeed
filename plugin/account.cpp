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

#include "account.h"

#include <QNetworkRequest>
#include <QNetworkReply>

#include <KAccounts/core.h>
#include <KAccounts/getcredentialsjob.h>

#include <Accounts/Manager>

Account::Account(QObject *parent)
    : QObject(parent)
{
}

Account::~Account()
{
}

QByteArray Account::requestToken()
{
    //TODO Make it possible to configure the accountid
    Accounts::Manager* mgr = KAccounts::accountsManager();
    auto accounts =  mgr->accountList(QStringLiteral("gmail-feed"));

    if (accounts.isEmpty()) {
        qWarning()<<"No Gmail account configured";
        return QByteArray();
    }
    Accounts::AccountId id = accounts.first();

    auto job = new GetCredentialsJob(id, this);
    bool b = job->exec();
    if (!b) {
        qWarning() << "Couldn't fetch credentials";
        return QByteArray();
    }

    //TODO: make async
    QByteArray accessToken = job->credentialsData()[QStringLiteral("AccessToken")].toByteArray();
    return accessToken;
}

void Account::getFeed()
{
    QNetworkRequest req(QUrl("https://mail.google.com/mail/feed/atom"));
    req.setRawHeader("Authorization", "Bearer "+requestToken());

    auto reply = m_manager.get(req);
    connect(reply, &QNetworkReply::readyRead, this, &Account::newData);
}

void Account::newData()
{
    QNetworkReply* reply = qobject_cast<QNetworkReply*>(sender());
    if (reply->error()) {
        qWarning() << "couldn't read data" << reply->readAll();
        return;
    }

    m_feed = QString(reply->readAll());
    Q_EMIT(feedChanged());
}
