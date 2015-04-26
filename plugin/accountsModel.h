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

#ifndef ACCOUNTSMODEL_H
#define ACCOUNTSMODEL_H

#include <QAbstractListModel>

#include <Accounts/Account>

class AccountsModel : public QAbstractListModel
{
    Q_OBJECT

public:
    enum  AccountRoles {
            NameRole = Qt::UserRole,
            IdRole = Qt::UserRole + 1
        };
    
    explicit AccountsModel(QObject *parent = 0);
    ~AccountsModel();

    QHash<int, QByteArray> roleNames() const;
    int rowCount(const QModelIndex & parent = QModelIndex()) const;
    QVariant data(const QModelIndex & index, int role = Qt::DisplayRole) const;

    Q_INVOKABLE int getId(int index) const;
    Q_INVOKABLE int indexOf(int id) const;

private Q_SLOTS:
    void accountCreated(Accounts::AccountId id);
    void accountRemoved(Accounts::AccountId id);

private:
    QList<Accounts::AccountId> m_accounts;
};

#endif
