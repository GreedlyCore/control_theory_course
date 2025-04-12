function latexMatrix = mat2tex(A, precision)
    % Проверка, что A - это матрица
    if ~ismatrix(A)
        error('Input must be a matrix.');
    end
    
    % Проверка, что precision - положительное целое число
    if ~isscalar(precision) || precision < 1 || floor(precision) ~= precision
        error('Precision must be a positive integer.');
    end

    % Начало LaTeX-кода с окружением bmatrix (квадратные скобки)
    lines = ["\begin{bmatrix}"];

    % Формирование строк матрицы
    for i = 1:size(A,1)
        rowElements = strings(1, size(A,2)); % Создаём строку строк для LaTeX
        for j = 1:size(A,2)
            elem = A(i,j);
            if isreal(elem)
                % Округляем число с нужной точностью
                roundedElem = round(elem, precision);
                
                % Проверка, является ли число целым (первые precision знаков после запятой - нули)
                if mod(roundedElem, 1) == 0
                    rowElements(j) = sprintf('%d', roundedElem);
                else
                    % Форматирование дробного числа с нужным precision
                    roundedElem = round(elem, precision);
                    rowElements(j) = regexprep(sprintf('%.*f', precision, roundedElem), '0+$', '');
                    rowElements(j) = regexprep(rowElements(j), '\.$', ''); % Убираем лишнюю точку, если осталась
                end
            else
                % Если элемент комплексный, разбираем его на части
                realPart = real(elem);
                imagPart = imag(elem);

                % Округляем обе части
                realPart = round(realPart, precision);
                imagPart = round(imagPart, precision);

                % Проверка, является ли действительная часть целым числом
                if mod(realPart, 1) == 0
                    realStr = sprintf('%d', realPart);
                else
                    realPart = round(realPart, precision);
                    realStr = regexprep(sprintf('%.*f', precision, realPart), '0+$', '');
                    realStr = regexprep(realStr, '\.$', '');
                end

                % Проверка, является ли мнимая часть целым числом
                if mod(imagPart, 1) == 0
                    imagStr = sprintf('%d', imagPart);
                else
                    imagPart = round(imagPart, precision);
                    imagStr = regexprep(sprintf('%.*f', precision, imagPart), '0+$', '');
                    imagStr = regexprep(imagStr, '\.$', '');
                end

                if realPart == 0
                    % Только мнимая часть
                    rowElements(j) = sprintf('%si', imagStr);
                elseif imagPart == 0
                    % Только действительная часть
                    rowElements(j) = realStr;
                else
                    % Полное комплексное число с правильными знаками
                    signChar = ' + ';
                    if imagPart < 0
                        signChar = ' - ';
                        imagStr = erase(imagStr, '-'); % Убираем минус, так как он уже указан
                    end
                    rowElements(j) = sprintf('%s%s%si', realStr, signChar, imagStr);
                end
            end
        end
        % Объединяем строку с `&` и добавляем её в LaTeX-матрицу
        lines = [lines; "    " + strjoin(rowElements, ' & ') + " \\"]; 
    end

    % Завершение окружения bmatrix
    lines = [lines; "\end{bmatrix}"];

    % Соединяем все строки без добавления `\n`
    latexMatrix = join(lines, newline);

    % Выводим отформатированную строку в командное окно
    disp(latexMatrix);
end
