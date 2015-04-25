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

#include <Accounts/Account>

class KJob;

class Account : public QObject
{
    Q_OBJECT

public:
    Q_PROPERTY(QString feed READ feed NOTIFY feedChanged)
    Q_PROPERTY(QString isConfigured READ isConfigured NOTIFY isConfiguredChanged)

    Q_INVOKABLE void updateFeed();
    
    explicit Account(QObject *parent = 0);
    ~Account();

    QString feed() const {return m_feed;}
    bool isConfigured() const {return m_isConfigured;}

Q_SIGNALS:
    void feedChanged();
    void isConfiguredChanged();

private Q_SLOTS:
    void credentialsReceived(KJob *job);
    void newData();
    void accountsChanged();

private:
    Accounts::AccountId m_id;
    QNetworkAccessManager m_networkManager;
    QString m_feed;
    bool m_isConfigured;
};

#endif
