# 1. Базовый образ
FROM python:3.12-slim

# 2. Установка зависимостей ОС
RUN apt-get update && apt-get install -y \
    build-essential \
    && rm -rf /var/lib/apt/lists/*

# 3. Рабочая директория
ENV PYTHONPATH=/home/ubuntu/app
WORKDIR ${PYTHONPATH}

# 4. Копирование зависимостей и исходников
COPY requirements.txt .

# Создаем виртуальное окружение и устанавливаем зависимости
RUN python -m venv venv \
    && venv/bin/pip install --upgrade pip \
    && venv/bin/pip install --no-cache-dir -r requirements.txt

COPY . .

# 5. Экспорт порта
EXPOSE 8181

# 6. Настройка PATH для использования бинарников из venv
ENV PATH="/home/ubuntu/app/venv/bin:$PATH"

# 7. Команда запуска
CMD ["uvicorn", "app.main:app", "--host", "0.0.0.0", "--port", "8181"]
