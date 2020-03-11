import 'package:breez/bloc/account/account_model.dart';
import 'package:breez/bloc/pos_catalog/actions.dart';
import 'package:breez/bloc/pos_catalog/bloc.dart';
import 'package:breez/bloc/pos_catalog/model.dart';
import 'package:breez/bloc/user_profile/currency.dart';
import 'package:breez/routes/charge/currency_wrapper.dart';
import 'package:breez/theme_data.dart' as theme;
import 'package:breez/widgets/flushbar.dart';
import 'package:fixnum/fixnum.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

import 'item_avatar.dart';

class CatalogItem extends StatelessWidget {
  final AccountModel accountModel;
  final PosCatalogBloc posCatalogBloc;
  final Item _itemInfo;
  final bool _lastItem;
  final Function(Item item) _addItem;

  CatalogItem(this.accountModel, this.posCatalogBloc, this._itemInfo,
      this._lastItem, this._addItem);

  @override
  Widget build(BuildContext context) {
    return Stack(alignment: Alignment.bottomCenter, children: <Widget>[
      Slidable(
        actionPane: SlidableDrawerActionPane(),
        actionExtentRatio: 0.25,
        secondaryActions: <Widget>[
          IconSlideAction(
            foregroundColor: Colors.white,
            color: Theme.of(context).primaryColorLight,
            icon: Icons.delete_forever,
            onTap: () {
              DeleteItem deleteItem = DeleteItem(_itemInfo.id);
              posCatalogBloc.actionsSink.add(deleteItem);
              deleteItem.future.catchError((err) => showFlushbar(context,
                  message: "Failed to delete ${_itemInfo.name}"));
            },
          ),
        ],
        key: Key(_itemInfo.id.toString()),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(0, 8, 8, 8),
          child: ListTile(
            leading: ItemAvatar(_itemInfo.imageURL),
            title: Text(
              _itemInfo.name,
              style: theme.transactionTitleStyle
                  .copyWith(fontWeight: FontWeight.bold),
              overflow: TextOverflow.ellipsis,
            ),
            trailing: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: <Widget>[
                Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      RichText(
                        text: TextSpan(
                          style: theme.transactionAmountStyle,
                          children: <InlineSpan>[
                            _buildCurrencySymbol(),
                            TextSpan(
                              text: _formattedPrice(), // Price
                            ),
                          ],
                        ),
                      ),
                    ]),
              ],
            ),
            onTap: () {
              _addItem(_itemInfo);
            },
          ),
        ),
      ),
      Divider(
        height: 0.0,
        color: _lastItem
            ? Color.fromRGBO(255, 255, 255, 0.0)
            : Color.fromRGBO(255, 255, 255, 0.12),
        indent: 72.0,
      ),
    ]);
  }

  InlineSpan _buildCurrencySymbol() {
    return _itemInfo.currency == "SAT"
        ? WidgetSpan(
            child: Container(
              height: 20,
              child: Align(
                child: Text(_getSymbol(), // Icon
                    style: TextStyle(fontSize: 13.4, fontFamily: 'SAT')),
                alignment: Alignment.center,
              ),
            ),
          )
        : TextSpan(
            text: _getSymbol(), // Icon
          );
  }

  String _getSymbol() {
    var currency = Currency.fromTickerSymbol(_itemInfo.currency);
    if (currency != null) {
      return currency.symbol;
    } else {
      return accountModel
          .getFiatCurrencyByShortName(_itemInfo.currency)
          .currencyData
          .symbol;
    }
  }

  String _formattedPrice({bool userInput = false, bool includeSymbol = true}) {
    var formatter =
        CurrencyWrapper.fromShortName(_itemInfo.currency, accountModel);
    return formatter.format(_itemInfo.price, removeTrailingZeros: true);
  }

  Int64 _itemPriceInSat() {
    return Currency.fromTickerSymbol(_itemInfo.currency) != null
        ? Currency.fromTickerSymbol(_itemInfo.currency).toSats(_itemInfo.price)
        : accountModel
            .getFiatCurrencyByShortName(_itemInfo.currency)
            .fiatToSat(_itemInfo.price);
  }
}