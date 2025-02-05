В текущей папке - тестируемая версия процессора.
В папке SYNTHESIS_ONLY - версии файлов, использованные для синтеза.
В файле Top_level_report.pdf - отчет команды топового уровня.

ОБРАТИТЕ ВНИМАНИЕ: в топовом уровне и памяти инструкций указан путь до программы "C:/RISC_V_TESTS/program_p8k.hex".

#Приличный результат компиляции:#

![compilation report balanced](https://github.com/user-attachments/assets/7928bc9e-199b-4ddc-98a7-6707ba7371ad)

#Инструкция по синтезу всего процессора в QUARTUS PRIME#
Избегайте кириллицу ВЕЗДЕ в путях к файлам!!!!!!
 
1. Создать проект
![image](https://github.com/user-attachments/assets/7abcd776-e82a-4f0e-ae09-6b08a6121229)
2. Добавить эти файлы из папки SYNTHESIS_ONLY из этого репозитория в проект:
![image](https://github.com/user-attachments/assets/55f4ba94-8adc-4461-a5e3-65f8446fb10d)
3. Установить файл RISC_V_PROCESSOR как top-level entity (правой кнопкой мыши по файлу RISC_V_PROCESSOR.vhd и выбрать set as top-level entity)
4. Компилировать (синтез + размещение на кристалле ПЛИС) на кнопочку:
![image](https://github.com/user-attachments/assets/74b80b63-baa9-45b9-95fe-51e5db1cbffc)

