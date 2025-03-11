#!/bin/bash

set -e

REPO="sjzsdu/yao-app-ts-types"
RELEASE_URL="https://api.github.com/repos/$REPO/releases/latest"

echo "正在获取最新版本信息..."
RELEASE_INFO=$(curl -s $RELEASE_URL)
VERSION=$(echo "$RELEASE_INFO" | grep '"tag_name":' | sed -E 's/.*"([^"]+)".*/\1/')

if [ -z "$VERSION" ]; then
    echo "错误：无法获取最新版本信息。"
    exit 1
fi

echo "获取到的版本: $VERSION"

# 提取所有 .json 文件的下载 URL
DOWNLOAD_URLS=$(echo "$RELEASE_INFO" | grep -o 'https://github.com/[^"]*\.json')

if [ -z "$DOWNLOAD_URLS" ]; then
    echo "错误：未找到可下载的 JSON 文件。"
    exit 1
fi

# 创建目标目录
SCHEMA_DIR="$HOME/.yao-app-ts-types/json-schemas/$VERSION"
mkdir -p "$SCHEMA_DIR"

# 下载所有文件
echo "$DOWNLOAD_URLS" | while read -r url; do
    filename=$(basename "$url")
    echo "正在下载 $filename ..."
    if curl -L "$url" -o "$SCHEMA_DIR/$filename"; then
        echo "成功下载 $filename"
    else
        echo "错误：下载 $filename 失败"
    fi
done

# 验证安装
if [ ! -f "$SCHEMA_DIR/form.json" ]; then
    echo "错误：schema 文件安装失败。"
    echo "目标目录内容："
    ls -l "$SCHEMA_DIR"
    exit 1
fi

# 生成 .vscode/settings.json 文件
echo "Generating .vscode/settings.json..."
mkdir -p .vscode
cat > .vscode/settings.json << EOL
{
  "json.schemas": [
    {
      "fileMatch": ["/**/*.mod.json", "/**/*.mod.jsonc", "/**/*.mod.yao"],
      "url": "file:/$SCHEMA_DIR/model.json"
    },
    {
      "fileMatch": ["/**/*app.json", "/**/*app.jsonc", "/**/*app.yao"],
      "url": "file:/$SCHEMA_DIR/app.json"
    },
    {
      "fileMatch": ["/**/*.login.json", "/**/*.login.jsonc", "/**/*.login.yao"],
      "url": "file:/$SCHEMA_DIR/login.json"
    },
    {
      "fileMatch": ["/**/*.schedule.json", "/**/*.schedule.jsonc", "/**/*.schedule.yao"],
      "url": "file:/$SCHEMA_DIR/schedule.json"
    },
    {
      "fileMatch": ["/**/*.service.json", "/**/*.service.jsonc", "/**/*.service.yao"],
      "url": "file:/$SCHEMA_DIR/service.json"
    },
    {
      "fileMatch": ["/**/*.socket.json", "/**/*.socket.jsonc", "/**/*.socket.yao"],
      "url": "file:/$SCHEMA_DIR/socket.json"
    },
    {
      "fileMatch": ["/**/*.stor.json", "/**/*.stor.jsonc", "/**/*.stor.yao"],
      "url": "file:/$SCHEMA_DIR/store.json"
    },
    {
      "fileMatch": ["/**/*.task.json", "/**/*.task.jsonc", "/**/*.task.yao"],
      "url": "file:/$SCHEMA_DIR/task.json"
    },
    {
      "fileMatch": ["/**/*.widget.json", "/**/*.widget.jsonc", "/**/*.widget.yao"],
      "url": "file:/$SCHEMA_DIR/widget.json"
    },
    {
      "fileMatch": ["/**/apis/**/*.ws.json", "/**/apis/**/*.ws.jsonc", "/**/apis/**/*.ws.yao"],
      "url": "file:/$SCHEMA_DIR/ws_server.json"
    },
    {
      "fileMatch": ["/**/websockets/**/*.ws.json", "/**/websockets/**/*.ws.jsonc", "/**/websockets/**/*.ws.yao"],
      "url": "file:/$SCHEMA_DIR/ws_client.json"
    },
    {
      "fileMatch": ["/**/*.imp.json", "/**/*.imp.jsonc", "/**/*.imp.yao"],
      "url": "file:/$SCHEMA_DIR/importer.json"
    },
    {
      "fileMatch": ["/**/*.http.json", "/**/*.http.jsonc", "/**/*.http.yao"],
      "url": "file:/$SCHEMA_DIR/api_http.json"
    },
    {
      "fileMatch": ["/**/*.rest.json", "/**/*.rest.jsonc", "/**/*.rest.yao"],
      "url": "file:/$SCHEMA_DIR/api_rest.json"
    },
    {
      "fileMatch": ["/**/*.chart.json", "/**/*.chart.jsonc", "/**/*.chart.yao"],
      "url": "file:/$SCHEMA_DIR/chart.json"
    },
    {
      "fileMatch": ["/**/*.tab.json", "/**/*.tab.jsonc", "/**/*.tab.yao"],
      "url": "file:/$SCHEMA_DIR/table.json"
    },
    {
      "fileMatch": ["/**/*.list.json", "/**/*.list.jsonc", "/**/*.list.yao"],
      "url": "file:/$SCHEMA_DIR/list.json"
    },
    {
      "fileMatch": ["/**/*.conn.json", "/**/*.conn.jsonc", "/**/*.conn.yao"],
      "url": "file:/$SCHEMA_DIR/connector.json"
    },
    {
      "fileMatch": ["/**/*.model.json", "/**/*.model.jsonc", "/**/*.model.yao"],
      "url": "file:/$SCHEMA_DIR/model.json"
    },
    {
      "fileMatch": ["/**/*.form.json", "/**/*.form.jsonc", "/**/*.form.yao", "!/**/dyforms/**/*.form.json", "!/**/dyforms/**/*.form.jsonc", "!/**/dyforms/**/*.form.yao"],
      "url": "file:/$SCHEMA_DIR/form.json"
    },
    {
      "fileMatch": ["/**/*.flow.json", "/**/*.flow.jsonc", "/**/*.flow.yao"],
      "url": "file:/$SCHEMA_DIR/flow.json"
    },
    {
      "fileMatch": ["/**/*.dash.json", "/**/*.dash.jsonc", "/**/*.dash.yao"],
      "url": "file:/$SCHEMA_DIR/dashboard.json"
    }
  ]
}
EOL


rm -rf "$TEMP_DIR"

echo "安装完成。JSON schemas 已安装到 $SCHEMA_DIR"
echo ".vscode/settings.json 已更新。"

if [ -f "$SCHEMA_DIR/form.json" ]; then
    echo "验证成功：schema 文件已正确安装。"
else
    echo "警告：安装可能不完整，请检查 $SCHEMA_DIR 目录。"
fi