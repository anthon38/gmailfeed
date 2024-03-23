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

#include "accountsModel.h"

#include <KAccounts/Core>

#include <Accounts/Manager>

AccountsModel::AccountsModel(QObject *parent)
    : QAbstractListModel(parent)
{
    auto accounts =  KAccounts::accountsManager()->accountList(QStringLiteral("gmail-feed"));
    Q_FOREACH(Accounts::AccountId id, accounts) {
        m_accounts.append(id);
    }

    connect(KAccounts::accountsManager(), &Accounts::Manager::accountCreated, this, &AccountsModel::accountCreated);
    connect(KAccounts::accountsManager(), &Accounts::Manager::accountRemoved, this, &AccountsModel::accountRemoved);
}

AccountsModel::~AccountsModel()
{
}

QHash<int, QByteArray> AccountsModel::roleNames() const
{
    QHash<int, QByteArray> roles;
    roles[NameRole] = "name";
    roles[IdRole] = "id";
    return roles;
}


int AccountsModel::rowCount(const QModelIndex & parent) const
{
    Q_UNUSED(parent)
    return m_accounts.size();
}

QVariant AccountsModel::data(const QModelIndex & index, int role) const
{
    if (!index.isValid()) {
        return QVariant();
    }

    if (index.row() >= m_accounts.size() || index.row() < 0) {
        return QVariant();
    }

    switch (role) {
        case IdRole:
            return m_accounts.at(index.row());
        case NameRole:
            return KAccounts::accountsManager()->account(m_accounts.at(index.row()))->displayName();
        default:
            return QVariant();
    }
}

void AccountsModel::accountCreated(Accounts::AccountId id)
{
    beginInsertRows(QModelIndex(), m_accounts.size(), m_accounts.size());
    m_accounts.append(id);
    endInsertRows();
}

void AccountsModel::accountRemoved(Accounts::AccountId id)
{
    int i = m_accounts.indexOf(id);
    if (i < 0) {
        return;
    }
    beginRemoveRows(QModelIndex(), i, i);
    m_accounts.removeAt(i);
    endRemoveRows();
}

int AccountsModel::getId(int index) const
{
    return int(m_accounts.at(index));
}

int AccountsModel::indexOf(int id) const
{
    return m_accounts.indexOf(id);
}
