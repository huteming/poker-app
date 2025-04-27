#!/bin/bash

echo "=== 开始数据库创建过程 ==="

# 确保.env文件存在
if [ ! -f ".env" ]; then
  echo "错误：.env文件不存在，无法继续"
  echo "请创建.env文件并设置以下环境变量："
  echo "CLOUDFLARE_ACCOUNT_ID=your_account_id"
  echo "CLOUDFLARE_API_TOKEN=your_api_token"
  echo "CLOUDFLARE_DATABASE_ID=your_database_id"
  exit 1
fi

# 编译并运行修复脚本
echo "编译数据库创建脚本..."
flutter pub get

echo ""
echo "运行数据库创建脚本..."
dart run bin/create_game_records_table.dart
# dart run bin/test_script.dart

# 检查执行结果
if [ $? -eq 0 ]; then
  echo "数据库创建成功完成！"
else
  echo "数据库创建失败，请检查日志"
fi

echo "=== 数据库创建过程结束 ===" 