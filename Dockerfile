# 篮球比赛积分计分程序 - 无文件复制版
FROM python:3.9-slim-bullseye

# 设置工作目录和时区
WORKDIR /app
ENV TZ=Asia/Shanghai
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

# 直接在容器中创建requirements.txt内容
RUN echo "PyQt5==5.15.9" > requirements.txt && \
    echo "openpyxl==3.1.2" >> requirements.txt

# 直接在容器中创建篮球程序文件（避免文件复制）
RUN echo "正在创建篮球计分程序文件..." && \
    echo "# 篮球计分程序主文件" > basketball_JF.py && \
    echo "# 此文件将在构建过程中被实际内容替换" >> basketball_JF.py

# 安装系统依赖
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

# 安装Python依赖
RUN pip install --no-cache-dir -r requirements.txt -i https://pypi.tuna.tsinghua.edu.cn/simple

# 设置环境变量
ENV QT_DEBUG_PLUGINS=0
ENV QT_QPA_PLATFORM=xcb
ENV DISPLAY=:0
ENV PYTHONUNBUFFERED=1

# 创建非root用户
RUN useradd -m -u 1000 appuser && chown -R appuser:appuser /app
USER appuser

# 注意：实际的主程序文件需要在构建后手动替换
# 或者使用其他方式注入实际代码
CMD ["python", "basketball_JF.py"]
