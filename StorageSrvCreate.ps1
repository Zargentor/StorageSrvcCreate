# Проверяем, запущен ли скрипт с правами администратора
if (-not ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()
    ).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {

    # Если нет — готовим новый процесс PowerShell с параметром "Запуск от имени администратора"
    $newProcess = New-Object System.Diagnostics.ProcessStartInfo "powershell";
    $newProcess.Arguments = "& '" + $myInvocation.MyCommand.Definition + "'";
    $newProcess.Verb = "runas";   # специальное значение для запуска от имени администратора
    [System.Diagnostics.Process]::Start($newProcess); # Запускаем процесс
    exit; # Выходим из текущего сеанса, чтобы не дублировать запуск
}

# ==== Параметры для будущей службы ====

$StartPort = "15"                # Начало номера порта, к которому будет добавляться "хвост" Iterator
$Iterator = "42"                 # Дополнение к порту (в итоге порт = 1542)
$platformVersion = "8.3.21.1644" # Версия платформы 1С
$platformVersionWithUnder = $platformVersion.Replace(".","_") # Подготовленная строка без точек для имени службы

$RepPath = """D:\repository"""   # Путь к хранилищу конфигурации 1С (каталог)
$crserverPath = """C:\Program Files\1cv8\$platformVersion\bin\crserver.exe""" 
# Путь до исполняемого файла crserver.exe, лежащего в дистрибутиве 1С

# ==== Формируем описание службы ====

$SrvcName = "1C:Enterprise 8.3 Configuration Repository Server $($StartPort)$($Iterator)"
# Внутреннее имя службы Windows

$DisplayName = "1C:Enterprise 8.3 Configuration Repository Server $($StartPort)$($Iterator)_$platformVersionWithUnder"
# Отображаемое имя службы в mmc/services.msc

$BinPath = "$crserverPath -srvc -port $($StartPort)$($Iterator) -d $RepPath"
# Команда запуска службы: указываем исполняемый файл crserver.exe, режим -srvc (служба),
# порт и каталог хранилища

# ==== Создание и запуск службы ====

New-Service -Name $SrvcName -BinaryPathName $BinPath -StartupType Automatic -Description $SrvcName -DisplayName $DisplayName
# Регистрируем новую службу Windows
# StartupType Automatic — запуск при старте системы
# DisplayName и Description задаются для удобной идентификации

Start-Service -Name $SrvcName
# Запускаем созданную службу
