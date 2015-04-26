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
    , m_id(0)
    , m_isConfigured(false)
{
}

Account::~Account()
{
}

void Account::updateFeed()
{
    if (!m_isConfigured) {
        qWarning()<<"No Gmail account configured";
        return;
    }

    auto job = new GetCredentialsJob(m_id, this);
    connect(job, &GetCredentialsJob::result, this, &Account::credentialsReceived);
    job->start();
}

void Account::credentialsReceived(KJob *job)
{
    GetCredentialsJob* credentials = qobject_cast<GetCredentialsJob*>(job);
    if (credentials->error()) {
        qWarning() << "Couldn't fetch credentials";
        return;
    }

    auto accessToken = credentials->credentialsData()[QStringLiteral("AccessToken")].toByteArray();

    QNetworkRequest req(QUrl("https://mail.google.com/mail/feed/atom"));
    req.setRawHeader("Authorization", "Bearer "+accessToken);

    auto reply = m_networkManager.get(req);
    connect(reply, &QNetworkReply::finished, this, &Account::newData);
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

void Account::setId(int id)
{
    if (id == 0) {
        m_id = 0;
        m_name.clear();
        m_isConfigured = false;
        Q_EMIT(isConfiguredChanged());
        Q_EMIT(idChanged());
        qWarning() << "account id set to 0.";
        return;
    }

    auto account = KAccounts::accountsManager()->account(qint32(id));
    if (!account) {
        qWarning() << "account id " << qint32(id) << "doesn't exist";
        return;
    }

    m_id = qint32(id);
    m_name = account->displayName();
    m_isConfigured = true;
    Q_EMIT(isConfiguredChanged());
    Q_EMIT(idChanged());
}
