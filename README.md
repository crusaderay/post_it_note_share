# Universal Links 服务端配置

这个目录包含了 Memo Sticky 应用的 Universal Links 服务端配置文件。

## 📁 文件结构

```
server_config/
├── apple-app-site-association          # iOS Universal Links 配置文件
├── .well-known/
│   └── apple-app-site-association      # 标准路径的配置文件副本
├── index.html                          # 应用未安装时的回退页面
├── deploy.sh                           # 自动部署脚本
└── README.md                           # 说明文档
```

## 🔧 配置说明

### apple-app-site-association

这是 iOS Universal Links 的核心配置文件，包含以下信息：

- **App ID**: `3HWBZVW7QW.com.dongjiezhang.Post-It-Notes`
- **支持的路径**: `/post_it_note_share/new`
- **域名**: `postitnoteshare.ray-zhang.xyz`

### index.html

智能回退页面，具有以下功能：

- 🎯 **智能平台检测**: 自动识别 iOS/Android 设备
- 📱 **便签预览**: 显示要创建的便签内容
- 🔄 **自动跳转**: 3秒后自动跳转到应用商店
- 🎨 **现代化UI**: 响应式设计，支持移动端
- 🌐 **多语言支持**: 中文界面

## 🚀 部署方式

### 方式一：使用自动部署脚本

```bash
# 进入配置目录
cd server_config

# 给脚本执行权限
chmod +x deploy.sh

# 运行部署脚本
./deploy.sh
```

脚本支持多种部署方式：
1. **本地测试** - 创建本地测试环境
2. **SCP部署** - 直接部署到远程服务器
3. **GitHub Pages** - 生成 GitHub Pages 配置
4. **手动部署** - 生成部署包

### 方式二：手动部署

#### 1. 上传文件到服务器

将以下文件上传到你的服务器：

```bash
# 上传到网站根目录
apple-app-site-association
index.html

# 创建 .well-known 目录并上传
mkdir .well-known
cp apple-app-site-association .well-known/
```

#### 2. 配置服务器

确保服务器正确配置：

**Nginx 配置示例：**
```nginx
server {
    listen 443 ssl;
    server_name postitnoteshare.ray-zhang.xyz;
    
    # SSL 配置...
    
    location /apple-app-site-association {
        add_header Content-Type application/json;
        add_header Access-Control-Allow-Origin *;
    }
    
    location /.well-known/apple-app-site-association {
        add_header Content-Type application/json;
        add_header Access-Control-Allow-Origin *;
    }
    
    location /post_it_note_share/new {
        try_files $uri /index.html;
    }
}
```

**Apache 配置示例：**
```apache
<VirtualHost *:443>
    ServerName postitnoteshare.ray-zhang.xyz
    
    # SSL 配置...
    
    <Files "apple-app-site-association">
        Header set Content-Type "application/json"
        Header set Access-Control-Allow-Origin "*"
    </Files>
    
    RewriteEngine On
    RewriteRule ^/post_it_note_share/new$ /index.html [L]
</VirtualHost>
```

### 方式三：GitHub Pages 部署

1. 创建新的 GitHub 仓库
2. 运行部署脚本选择 GitHub Pages 选项
3. 将生成的文件推送到仓库
4. 在仓库设置中启用 GitHub Pages
5. 配置自定义域名为 `postitnoteshare.ray-zhang.xyz`

## ✅ 验证部署

部署完成后，请验证以下URL：

### 1. 配置文件访问
```bash
# 检查主配置文件
curl -I https://postitnoteshare.ray-zhang.xyz/apple-app-site-association
# 应该返回: Content-Type: application/json

# 检查标准路径配置文件
curl -I https://postitnoteshare.ray-zhang.xyz/.well-known/apple-app-site-association
# 应该返回: Content-Type: application/json
```

### 2. Universal Link 测试
```bash
# 在 Safari 中测试（真实设备）
https://postitnoteshare.ray-zhang.xyz/post_it_note_share/new?text=Hello%20World

# 应该：
# - 如果安装了应用：直接打开应用并创建便签
# - 如果未安装应用：显示下载页面
```

### 3. 配置文件内容验证
```bash
# 验证JSON格式
curl https://postitnoteshare.ray-zhang.xyz/apple-app-site-association | python3 -m json.tool
```

## 🔍 故障排除

### 常见问题

1. **Universal Link 不工作**
   - ✅ 确保使用 HTTPS
   - ✅ 检查 Content-Type 是否为 `application/json`
   - ✅ 验证 App ID 和路径配置
   - ✅ 在真实设备上测试（模拟器可能不完全支持）

2. **配置文件无法访问**
   - ✅ 检查文件权限
   - ✅ 确保没有 `.json` 扩展名
   - ✅ 检查服务器配置

3. **应用不打开**
   - ✅ 确保应用已安装
   - ✅ 检查 Bundle ID 是否匹配
   - ✅ 验证应用签名
   - ✅ 重启设备并重新安装应用

### 调试工具

```bash
# 检查DNS解析
nslookup postitnoteshare.ray-zhang.xyz

# 检查SSL证书
openssl s_client -connect postitnoteshare.ray-zhang.xyz:443 -servername postitnoteshare.ray-zhang.xyz

# 检查HTTP响应
curl -v https://postitnoteshare.ray-zhang.xyz/apple-app-site-association
```

## 📱 测试流程

### 1. 开发测试
```bash
# 本地测试
cd server_config
./deploy.sh
# 选择选项 1 (本地测试)
cd local_test
python3 -m http.server 8000
# 访问 http://localhost:8000/postitnoteshare.ray-zhang.xyz/
```

### 2. 生产测试
1. 部署到生产服务器
2. 在真实 iOS 设备上测试
3. 使用 Safari 打开测试链接
4. 验证应用是否正确打开

## 🔄 更新配置

如需修改配置：

1. 编辑 `apple-app-site-association` 文件
2. 同步更新 `.well-known/apple-app-site-association`
3. 重新部署
4. 清除设备上的关联缓存（重启设备或重新安装应用）

## 📞 支持

如果遇到问题：

1. 检查本文档的故障排除部分
2. 验证所有配置文件格式正确
3. 确保服务器配置符合要求
4. 在真实设备上进行测试

---

**注意**: Universal Links 需要在真实设备上测试，模拟器可能无法完全模拟所有功能。