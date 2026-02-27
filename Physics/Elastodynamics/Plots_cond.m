%% For p = 1
Ns = [300, 500, 800];
Mat_loc = '/home/cristian/Desktop/Polimi/NAPDE/PROG/Condividere/Conv/Files/';
p = '1';
cond_1    = [];

for i = 1:3
    A = PetscBinaryRead([Mat_loc, 'A_', num2str(Ns(i)), '_p', p, '.dat']);
    cond_1(i) = (condest(A));
    
end

p = '2';
cond_2    = [];

for i = 1:3
    A = PetscBinaryRead([Mat_loc, 'A_', num2str(Ns(i)), '_p', p, '.dat']);
    cond_2(i) = (condest(A));
end

p = '3';
cond_3    = [];

for i = 1:3
    A = PetscBinaryRead([Mat_loc, 'A_', num2str(Ns(i)), '_p', p, '.dat']);
    cond_3(i) = (condest(A));
end


figure(1)
semilogy(Ns, cond_1, '-*', 'LineWidth', 2);
hold on
semilogy(Ns, cond_2, '-*', 'LineWidth', 2);
semilogy(Ns, cond_3, '-*', 'LineWidth', 2);
legend("P = 1", "P = 2", "P = 3")
xlabel('N')
ylabel('Condition Number')
grid on

%% 
Da scrivere nella presentazione: ci ricordiamo che nei sistemi lineari il 
residuo dipende dal numero di condizionamento. La stima del numero di condizionamento
nei DG dipende da h e p. Cerca le stime