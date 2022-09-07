clc
clear

% Elegimos matlab porque como su nombre lo dice es un laboratorio de
% matrices, además de que el primer elemento de un arreglo empieza desde 1
% a diferencia de otros lenguajes que empieza en 0, lo cual lo hace
% bastante conveniente para el problema a resolver.

% En Matlab los input binarios son almacenados como strings
vec_bin = input("(Emisor) Ingrese el vector en código binario: ", "s");

% El string recibido se convierte en un vector
vec_bin = num2cell(vec_bin);

% Posteriormente cada elemento del vector se convierte de str a double
vec_bin = str2double(vec_bin);

% Bucle para determinar cuántos son los bits de paridad
n_b = 1;
while true
    if 2^(n_b) < (n_b + length(vec_bin) + 1)
       n_b = n_b + 1; 
    else 
        break
    end
end

% Creando el vector de los bits de paridad y del dato ingresado
cont = length(vec_bin) + n_b; % tamaño del vector de paridad y de datos
cont_vec = 1; % contador del vector binario ingresado
cont_nb = 0; % contador del número de bits de paridad
k = 1; % iterador
while k <= cont
    % Si la posición actual coincide con un bit de paridad
    if 2^cont_nb == k
        % el 2 es un identificador para cambiar su valor después de haber
        % creado el vector con los datos y los bits de paridad
        vec_par(k) = 2; 
        cont_nb = cont_nb + 1;
    else
        vec_par(k) = vec_bin(cont_vec);
        cont_vec = cont_vec + 1;
    end
    k = k + 1;
end


% Creando una matriz de las posiciones correspondientes de cada bit de
% paridad, cada fila es un bit de paridad y cada columna es la posición
% correspondiente del respectivo bit de paridad
for k = 0:n_b-1
    
    x = 2^k;
    j = x; % iterador del while
    q = 1; % iterador del vector de las posiciones
   
     while j <= cont % bucle que construye la fila de bits de paridad k
          aux = x; 
      
         while aux > 0 & j <= cont % bucle que construye las posiciones del bit de paridad k
           pos(k+1,q) = j;
           j = j + 1;
           q = q + 1;
             aux = aux - 1;
          end
      
      j = j + x;
      
      end
    
end
  
% Creando el vector con los datos ingresados y los bits de paridad ya en
% orden
for j = 1:n_b
    cont_ones = 0; % contador de 1's
    
    for k = 1:length(pos) % bucle que lee cada columna de una fila de la matriz de posiciones de los bits de paridad
        if pos(j,k) == 0 % Si el elemento actual de la matriz de posiciones de los bits de paridad es igual a 0 ya no tiene más posiciones dicho bit de paridad
            break
        end
  
        if vec_par(pos(j,k)) ~= 2 % Si la posición actual no es de los bits de paridad
            if vec_par(pos(j,k)) == 1 % Si el elemento de la posición actual es 1 el contador aumenta
                cont_ones = cont_ones + 1;
            end
        end
    end
    
    % Cuando termine de leer las posiciones de los bits de paridad otorga
    % un valor dependiendo si la cantidad de 1´s es par o no
    if mod(cont_ones,2) == 0
       vec_par(2^(j-1)) = 0; 
    else
       vec_par(2^(j-1)) = 1;  
    end
end

fprintf("\n(Emisor) El código que se enviará con sus bits de paridad es: ")
% Convirtiendo el vector binario a char y luego a string
disp(convertCharsToStrings(sprintf('%.0f',vec_par)))

% Se seleccionará una posición aleatoria del vector de datos y de los bits
% de paridad para invertir su valor
dmg = randi(length(vec_par), 1);



vec_dmg = vec_par; % Se crea el vector dañado y se cambia el valor de la respectiva posición
if vec_dmg(dmg) == 1
    vec_dmg(dmg) = 0;
else 
    vec_dmg(dmg) = 1;
end

fprintf("\n(Receptor) Mensaje recibido: ")
% Convirtiendo el vector binario a char y luego a string
disp(convertCharsToStrings(sprintf('%.0f',vec_dmg)))

% Operación XOR de las posiciones de los bits de paridad del vector dañado
for j = 1:n_b % recorriendo filas de la matriz de posiciones de los bits de paridad
    
    x_or = xor(vec_dmg(pos(j,1)),vec_dmg(pos(j,2)));
    
    if length(pos) > 2 % el siguiente bloque de código solo se ejecuta si el número de posiciones es mayor a 2
        for k = 3:length(pos) % recorriendo columnas de cada fila de la matriz de posiciones de los bits de paridad
        
            % Si el elemento actual de la matriz de las posiciones del bit de
            % paridad respectivo es 0 entonces ya no tiene más posiciones
            if pos(j,k) == 0 
                break
            end
        
            x_or = xor(x_or,vec_dmg(pos(j,k)));
        end
    end
    
    xor_vec(1, j) = x_or;
    
end

% Obteniendo la posición del bit incorrecto
pos_bit = 0;
for k = 1:length(xor_vec)
   if xor_vec(k) == 1
       pos_bit = pos_bit + 2^(k-1);
   end
end

% Corrigiendo el bit dañado
if vec_dmg(pos_bit) == 1
    vec_dmg(pos_bit) = 0;
else
    vec_dmg(pos_bit) = 1;
end


fprintf("\nEl bit dañado se encuentra en la posición %-1.0f\n", pos_bit)
fprintf("\nPor lo tanto el mensaje correcto es: ")
% convirtiendo el vector binario a char y luego a str
disp(convertCharsToStrings(sprintf('%.0f',vec_dmg)))
