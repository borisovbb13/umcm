#include "indicators_model.hpp"

IndicatorsModel::IndicatorsModel (QObject *_parent)
    : QAbstractListModel(_parent)
{
}

void IndicatorsModel::init (int _channelsCount)
{
    for (int i = 0; i < _channelsCount; ++i)
    {
        IndicatorItem _item;
        _item.value = 0;
        _item.channel = i;
        _item.range = 3;
        _item.state = -1;

        m_indicators.push_back(_item);
    }
}

int IndicatorsModel::rowCount (const QModelIndex &_parent) const
{
    Q_UNUSED(_parent)
    return m_indicators.size();
}

QVariant IndicatorsModel::data (const QModelIndex &_index, int _role) const
{
    if (!_index.isValid())
        return QVariant();

    if (_index.row() >= m_indicators.size() || _index.row() < 0)
        return QVariant();

    const IndicatorItem _item = m_indicators.at(_index.row());

    switch (_role)
    {
    case ValueRole   : return _item.value;
    case ChannelRole : return _item.channel;
    case RangeRole   : return _item.range;
    case StateRole   : return _item.state;
    }

    return QVariant();
}

QHash<int, QByteArray> IndicatorsModel::roleNames () const
{
    QHash<int, QByteArray> _roles;
    _roles[ValueRole]   = "value";
    _roles[ChannelRole] = "channel";
    _roles[RangeRole]   = "range";
    _roles[StateRole]   = "state";
    return _roles;
}

int IndicatorsModel::rangeAt (int _channel)
{
    const QModelIndex _index = createIndex(_channel, 0);
    return data(_index, RangeRole).toInt();
}

void IndicatorsModel::updateRange (int _channel, int _range)
{
    if (_channel < 0 || _channel >= m_indicators.size())
        return;

     beginResetModel();
     m_indicators[_channel].range = _range;
     endResetModel();
}

void IndicatorsModel::updateValue (int _channel, qreal _value)
{
    if (_channel < 0 || _channel >= m_indicators.size())
        return;

    beginResetModel();
    m_indicators[_channel].value = _value;
    endResetModel();
}

void IndicatorsModel::updateState (int _channel, int _state)
{
    if (_channel < 0 || _channel >= m_indicators.size())
        return;

    beginResetModel();
    m_indicators[_channel].state = _state;
    endResetModel();
}
