#!/bin/bash

# 数据库迁移脚本
# 用法: ./tools/migrate.sh

# 确保在项目根目录下运行
SCRIPT_DIR=$(dirname "$0")
cd "$SCRIPT_DIR/.." || exit 1

echo "正在安装依赖..."
flutter pub get

echo "正在运行数据库迁移工具..."
dart tools/migrate_db.dart

if [ $? -eq 0 ]; then
  echo "迁移完成!"
else
  echo "迁移失败，请查看上面的错误信息"
  exit 1
fi 