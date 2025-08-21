# 1C Configuration Repository Service Deployment

Этот проект содержит PowerShell‑скрипт для автоматической установки и запуска **службы хранилища конфигурации 1С:Предприятие (Configuration Repository Server)** на Windows‑сервере.  
Скрипт позволяет быстро разворачивать TCP‑хранилище конфигураций, поддерживать разные версии платформы и автоматизировать администрирование.

---

## 📌 Возможности

- Автоматическая проверка и повышение прав до **администратора**.
- Создание Windows‑службы для `crserver.exe` с нужными параметрами.
- Гибкая настройка порта, версии платформы и каталога хранилища.
- Автоматический запуск службы после регистрации.
- Поддержка множественной установки (несколько CRServer с разными портами и версиями).

---

## 🛠 Требования

- Windows Server / Windows 10/11  
- Установленная платформа **1С:Предприятие 8.3**  
- Доступ к исполняемому файлу `crserver.exe` (обычно:  
  `C:\Program Files\1cv8\<версия>\bin\crserver.exe`)  
- Права администратора  

---

## 🚀 Установка и запуск

1. Склонируйте репозиторий или скачайте скрипт:

git clone [https://github.com/YOUR_GITHUB/1c-crserver-deploy.git](https://github.com/Zargentor/StorageSrvcCreate.git)
cd StorageSrvcCreate

text

2. Отредактируйте переменные в скрипте `deploy-crservice.ps1`:

$StartPort = "15" # Начало номера порта
$Iterator = "42" # Итератор для уникализации порта (в итоге порт = 1542)
$platformVersion = "8.3.21.1644" # Версия установленной платформы 1С
$RepPath = "D:\repository" # Путь к каталогу хранилища конфигурации

text

3. Запустите скрипт:

.\StorageSrvcCreate.ps1



4. После выполнения появится новая служба в `services.msc`, например:

- **Имя службы (Service Name):**  
  `1C:Enterprise 8.3 Configuration Repository Server 1542`

- **Отображаемое имя (Display Name):**  
  `1C:Enterprise 8.3 Configuration Repository Server 1542_8_3_21_1644`

---

## 🧩 Пример конфигурации

При параметрах:
$StartPort = "15"
$Iterator = "42"
$platformVersion = "8.3.21.1644"


Итоговые параметры будут:  
- TCP‑порт: **1542**  
- Имя службы: **1C:Enterprise 8.3 Configuration Repository Server 1542**  
- Отображаемое имя: **1C:Enterprise 8.3 Configuration Repository Server 1542_8_3_21_1644**

---

## 🗑 Управление и удаление службы

Для удаления службы можно воспользоваться PowerShell‑командой:

Stop-Service -Name "1C:Enterprise 8.3 Configuration Repository Server 1542" -Force
sc.exe delete "1C:Enterprise 8.3 Configuration Repository Server 1542"

*(подставьте свой порт и имя службы)*

## ⚠️ Замечания

- На одном сервере можно поднять несколько служб CRServer, но **порты должны быть разными**.  
- Каталоги репозиториев также рекомендуется разделять.  
- Имя службы и порт формируются автоматически на основе переменных `$StartPort` и `$Iterator`.

---

## 📄 Лицензия

Проект распространяется под лицензией **MIT**. Вы можете использовать и модифицировать его свободно.
