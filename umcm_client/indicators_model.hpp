#ifndef INDICATORS_MODEL_HPP
#define INDICATORS_MODEL_HPP

#include <QtCore/QAbstractListModel>

class IndicatorItem
{
public:
    int   channel;
    qreal value;
    int   range;
    int   state;
};

class IndicatorsModel : public QAbstractListModel
{
    Q_OBJECT

public:
    enum Role
    {
        ValueRole   = Qt::DisplayRole,
        ChannelRole = Qt::UserRole,     // 256
        RangeRole   = Qt::UserRole + 1,
        StateRole   = Qt::UserRole + 2
    };

    IndicatorsModel (QObject *_parent = nullptr);

    void init (int _channelsCount);

    int rowCount (const QModelIndex &_parent = QModelIndex()) const override;
    QVariant data (const QModelIndex &_index, int _role = Qt::DisplayRole) const override;
    QHash<int, QByteArray> roleNames () const override;

    Q_INVOKABLE int rangeAt (int _channel);

    Q_INVOKABLE void updateRange (int _channel, int _range);
    Q_INVOKABLE void updateValue (int _channel, qreal _value);
    Q_INVOKABLE void updateState (int _channel, int _state);

private:
    QList<IndicatorItem> m_indicators;
};

#endif // INDICATORS_MODEL_HPP
