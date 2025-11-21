#!/usr/bin/env dart
// Figma API 連線測試腳本
// 用途：驗證 Figma Personal Access Token 設定是否正確
// 執行：dart tools/test_figma_connection.dart

import 'dart:io';
import 'dart:convert';

Future<void> main() async {
  print('🔧 Figma API 連線測試工具');
  print('=' * 50);
  print('');

  // 讀取環境變數
  final token = Platform.environment['FIGMA_ACCESS_TOKEN'];
  final fileKey = Platform.environment['FIGMA_FILE_KEY'];

  // 檢查環境變數
  if (token == null || token.isEmpty) {
    print('❌ 錯誤: FIGMA_ACCESS_TOKEN 環境變數未設定');
    print('');
    print('請按照以下步驟設定：');
    print('1. 複製 .env.example 為 .env');
    print('2. 在 Figma 產生 Personal Access Token');
    print('3. 將 token 填入 .env 檔案');
    print('');
    print('詳細說明請見: docs/figma-setup.md');
    exit(1);
  }

  if (fileKey == null || fileKey.isEmpty) {
    print('❌ 錯誤: FIGMA_FILE_KEY 環境變數未設定');
    print('');
    print('請在 .env 檔案中設定您的 Figma File Key');
    print('File Key 可從 Figma URL 取得：');
    print('https://www.figma.com/file/{FILE_KEY}/File-Name');
    exit(1);
  }

  print('✅ 環境變數檢查通過');
  print('   Token: ${_maskToken(token)}');
  print('   File Key: $fileKey');
  print('');

  // 測試 API 連線
  print('🔍 正在連線到 Figma API...');
  
  try {
    final client = HttpClient();
    final request = await client.getUrl(
      Uri.parse('https://api.figma.com/v1/files/$fileKey'),
    );
    request.headers.set('X-Figma-Token', token);
    
    final response = await request.close();
    final responseBody = await response.transform(utf8.decoder).join();
    
    print('   回應狀態碼: ${response.statusCode}');
    print('');

    if (response.statusCode == 200) {
      final data = json.decode(responseBody);
      
      print('✅ 連線成功！');
      print('=' * 50);
      print('');
      print('📋 檔案資訊：');
      print('   名稱: ${data['name']}');
      print('   最後修改: ${data['lastModified']}');
      print('   版本: ${data['version']}');
      print('   縮圖 URL: ${data['thumbnailUrl'] ?? 'N/A'}');
      
      if (data['document'] != null) {
        final doc = data['document'];
        print('');
        print('📄 文件結構：');
        print('   類型: ${doc['type']}');
        print('   子節點數: ${(doc['children'] as List?)?.length ?? 0}');
      }
      
      print('');
      print('🎉 Figma API 設定完成！您現在可以開始使用 Figma 整合功能。');
      
    } else if (response.statusCode == 403) {
      print('❌ 連線失敗：權限被拒');
      print('');
      print('可能原因：');
      print('1. Token 無效或已過期');
      print('2. Token 權限不足（需要 file content 讀取權限）');
      print('3. 您沒有該檔案的存取權限');
      print('');
      print('解決方案：');
      print('1. 檢查 Token 是否正確複製');
      print('2. 在 Figma 重新產生 Token 並確保勾選正確權限');
      print('3. 確認您有該檔案的檢視權限');
      exit(1);
      
    } else if (response.statusCode == 404) {
      print('❌ 連線失敗：檔案未找到');
      print('');
      print('可能原因：');
      print('1. File Key 不正確');
      print('2. 檔案已被刪除或移動');
      print('3. 檔案不屬於您的帳號');
      print('');
      print('請檢查 .env 中的 FIGMA_FILE_KEY 是否正確');
      exit(1);
      
    } else {
      print('❌ 連線失敗');
      print('');
      print('狀態碼: ${response.statusCode}');
      print('錯誤訊息: $responseBody');
      exit(1);
    }
    
    client.close();
    
  } catch (e) {
    print('❌ 發生錯誤: $e');
    print('');
    print('請檢查：');
    print('1. 網路連線是否正常');
    print('2. Token 和 File Key 是否正確設定在 .env 檔案中');
    exit(1);
  }
}

String _maskToken(String token) {
  if (token.length <= 8) return '****';
  return '${token.substring(0, 5)}...${token.substring(token.length - 3)}';
}
