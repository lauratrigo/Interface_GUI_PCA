% Definir caminhos dos arquivos
arquivo_entrada = 'estacoes_coords.txt';
arquivo_saida = 'estacoes_coords_formatado.txt';

% Abrir o arquivo para leitura
fid = fopen(arquivo_entrada, 'r');

% Pular a primeira linha (cabeçalho)
headerLine = fgetl(fid);

% Ler os dados com separação flexível (múltiplos espaços ou tabs)
data = textscan(fid, '%s %f %f', 'Delimiter', ' ', 'MultipleDelimsAsOne', true);

% Fechar o arquivo de entrada
fclose(fid);

% Extrair colunas
Sigla = strtrim(data{1});      % Remove espaços extras
Latitude = data{2};
Longitude = data{3};

% Remover linhas com dados faltantes
validRows = ~isnan(Latitude) & ~isnan(Longitude);
Sigla = Sigla(validRows);
Latitude = Latitude(validRows);
Longitude = Longitude(validRows);

% Abrir o arquivo para escrita
fileID = fopen(arquivo_saida, 'w');

% Cabeçalho alinhado
fprintf(fileID, '%-6s %10s %12s\n', 'Sigla', 'Latitude', 'Longitude');

% Escrever os dados alinhados
for i = 1:length(Sigla)
    fprintf(fileID, '%-6s %10.3f %12.3f\n', Sigla{i}, Latitude(i), Longitude(i));
end

% Fechar o arquivo
fclose(fileID);

% Mensagem de sucesso
fprintf('Arquivo formatado e alinhado salvo como: %s\n', arquivo_saida);