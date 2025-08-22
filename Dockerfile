# 篮球比赛积分计分程序 - 腾讯云优化版
FROM python:3.9-slim-bullseye

# 设置工作目录和时区
WORKDIR /app
ENV TZ=Asia/Shanghai
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

# 复制项目文件
COPY basketball_JF.py .
COPY requirements.txt .

# 安装系统依赖（GUI应用所需）
RUN apt-get update && apt-get install -y --no-install-recommends \
    libgl1-mesa-glx \
    libglib2.0-0 \
    libxcb1 \
    libxext6 \
    libx11-6 \
    libxkbcommon-x11-0 \
    libfontconfig1 \
    libfreetype6 \
    fonts-wqy-microhei \
    && rm -rf /var/lib/apt/lists/* \
    && apt-get clean

# 安装Python依赖（使用国内镜像加速）
RUN pip install --no-cache-dir -r requirements.txt -i https://pypi.tuna.tsinghua.edu.cn/simple

# 设置环境变量
ENV QT_DEBUG_PLUGINS=0
ENV QT_QPA_PLATFORM=xcb
ENV DISPLAY=:0
ENV PYTHONUNBUFFERED=1

# 创建非root用户运行（安全最佳实践）
RUN useradd -m -u 1000 appuser && chown -R appuser:appuser /app
USER appuser

# 设置入口点
ENTRYPOINT ["python", "basketball_JF.py"]
