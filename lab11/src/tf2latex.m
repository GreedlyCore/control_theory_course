function latex_str = tf2latex(sys)
    [ny, nu] = size(sys);
    latex_str = '\begin{bmatrix}';
    for i = 1:ny
        for j = 1:nu
            [num, den] = tfdata(sys(i,j), 'v');
            if all(num == 0)
                element = '0';
            else
                num_str = poly2latex(num, 's');
                den_str = poly2latex(den, 's');
                element = sprintf('\\frac{%s}{%s}', num_str, den_str);
            end
            latex_str = [latex_str, element];
            if j < nu
                latex_str = [latex_str, ' & '];
            end
        end
        if i < ny
            latex_str = [latex_str, ' \\\\ '];
        end
    end
    latex_str = [latex_str, '\end{bmatrix}'];
end

function str = poly2latex(coeffs, var)
    idx = find(coeffs ~= 0, 1);
    if isempty(idx)
        str = '0';
        return;
    end
    coeffs = coeffs(idx:end);
    
    str = '';
    n = length(coeffs);
    for i = 1:n
        exponent = n - i;
        coeff = coeffs(i);
        if coeff == 0
            continue;
        end
        
        % Округление коэффициента до двух знаков
        roundedCoeff = round(coeff * 100) / 100;
        
        % Форматирование знака
        if i > 1
            if roundedCoeff > 0
                str = [str, ' + '];
            else
                str = [str, ' - '];
                roundedCoeff = -roundedCoeff;
            end
        elseif roundedCoeff < 0
            str = [str, '-'];
            roundedCoeff = -roundedCoeff;
        end
        
        % Преобразование в строку с удалением лишних нулей
        term = num2str(roundedCoeff, '%.2f');
        term = strrep(term, '.00', '');
        term = regexprep(term, '(\.[1-9])0+$', '$1');
        term = regexprep(term, '\.0$', '');
        
        % Форматирование степени переменной
        if exponent == 0
            term = [term];
        elseif exponent == 1
            term = [term, var];
        else
            term = [term, var, '^{', num2str(exponent), '}'];
        end
        
        str = [str, term];
    end
end