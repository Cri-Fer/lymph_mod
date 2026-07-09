f_scacchiera = mu15;

% 3. Generazione della griglia fitta limitata strettamente tra 0 e 1
[X, Y] = meshgrid(0:0.002:1, 0:0.002:1);

% 4. Valutazione della funzione (Ora funzionerà perfettamente!)
Z = f_scacchiera(X, Y);

% 5. Grafico 3D a gradini perfetti
figure;
surf(X, Y, Z, 'EdgeColor', 'none');

% 6. Ottimizzazione della visualizzazione tra 0 e 1

colorbar;
view(-37.5, 60);         
axis([0 1 0 1 0 3]);     
xlabel('Asse X (0-1)'); 
ylabel('Asse Y (0-1)'); 
zlabel('Altezza Z (0-1)');
title(['Scacchiera 0-1 con quadrati di lato ', 0.1]);
grid on;