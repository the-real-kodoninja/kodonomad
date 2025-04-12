import 'package:web3dart/web3dart.dart';
import 'package:http/http.dart' as http;

class CryptoService {
  final client = Web3Client('https://your-ethereum-node', http.Client());

  Future<void> rewardCrypto(int profileId, int distance) async {
    final amount = distance * 0.001; // 0.001 ETH per mile
    await supabase.instance.client.from('crypto_rewards').insert({
      'profile_id': profileId,
      'amount': amount,
      'type': 'ETH',
      'distance': distance,
    });
    // Transfer ETH to user's wallet_address
  }

  Future<void> mintNFT(int profileId, String metadata) async {
    // Mint NFT on Motoko/Internet Computer (simplified)
    await supabase.instance.client.from('nfts').insert({
      'profile_id': profileId,
      'token_id': 'NFT_${DateTime.now().millisecondsSinceEpoch}',
      'metadata': metadata,
    });
  }
}

final cryptoServiceProvider = Provider((ref) => CryptoService());
