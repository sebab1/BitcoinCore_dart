import 'dart:convert';
import 'package:http/http.dart' as http;

void main() {
  listWallets();
  getBalance();
  //getNewAddress();
  getNetworkDiffuculty();
  createRawTransaction();
}

//Opret en raw transaction med det gældende txid (kan findes via cli-kommando "listunspent 1") der sender 2.5 BTC til den gældende addresse. (Virker ikke, får statuscode 500. Virker med cli-kommando)
void createRawTransaction() async {
  var headers = {
    'content-type': 'text/plain;',
  };

  var data = utf8.encode(
      '{"jsonrpc": "1.0", "id": "curltest", "method": "createrawtransaction", "params": ["[{\"txid\":\"b4052422206080a50663751009a2174cb2fd456468a274c7e6c3a8e02bfcd9ff\",\"vout\":0}]" "[{\"bcrt1qgkdqfj90v24ukhzw2cc8q53l2jpm5dclx462ul\":\"2.5\"}]');

  var url = Uri.parse(
      'http://user:pass@127.0.0.1:18443/'); //Sender username ("user") og password ("pass") med til serveren så vi kan lave post-requests til Bitcoin Core
  var res = await http.post(url, headers: headers, body: data);
  if (res.statusCode != 200)
    throw Exception('http.post error: statusCode= ${res.statusCode}');
  print(res.body);
}

//Lad os finde den nuværende sværhedsgrad for mining (Meget lille tal da vi er på Regtest-netværket)
void getNetworkDiffuculty() async {
  var headers = {
    'content-type': 'text/plain;',
  };

  var data = utf8.encode(
      '{"jsonrpc": "1.0", "id": "curltest", "method": "getdifficulty", "params": []}');

  var url = Uri.parse('http://user:pass@127.0.0.1:18443/');
  var res = await http.post(url, headers: headers, body: data);
  if (res.statusCode != 200)
    throw Exception('http.post error: statusCode= ${res.statusCode}');
  print("Mining difficulty: " + res.body);
}

//Find ud af hvor mange wallets der er forbundet til Bitcoin Core på netværket
void listWallets() async {
  var headers = {
    'content-type': 'text/plain;',
  };

  var data = utf8.encode(
      '{"jsonrpc": "1.0", "id": "curltest", "method": "listwallets", "params": []}');

  var url = Uri.parse('http://user:pass@127.0.0.1:18443/');
  var res = await http.post(url, headers: headers, body: data);
  if (res.statusCode != 200)
    throw Exception('http.post error: statusCode= ${res.statusCode}');
  print("Active wallets on the network: " + res.body);
}

//Vis mængden af coins i den givende wallet (wallet1 i dette tilfælde)
void getBalance() async {
  var headers = {
    'content-type': 'text/plain;',
  };

  var wallet = 'wallet1';

  var data = utf8.encode(
      '{"jsonrpc": "1.0", "id": "curltest", "method": "getbalance", "params": []}');

  var url = Uri.parse('http://user:pass@127.0.0.1:18443/wallet/${wallet}');
  var res = await http.post(url, headers: headers, body: data);
  if (res.statusCode != 200)
    throw Exception('http.post error: statusCode= ${res.statusCode}');
  print("Current balance of " + wallet + ": " + res.body);
}
