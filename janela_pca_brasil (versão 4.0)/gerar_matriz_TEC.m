 function matriz = gerar_matriz_TEC(pasta, dias_escolhidos, estacoes_ref)


% Verifica se a pasta existe
    if ~isfolder(pasta)
        error('A pasta selecionada não existe.');
    end

    % Lista todos os arquivos .txt da pasta
    files_struct = dir(fullfile(pasta, '*.txt'));
    if isempty(files_struct)
        error('Não foram encontrados arquivos .txt na pasta selecionada.');
    end
    files = {files_struct.name};

    horas_por_dia = 1440;
    matriz = [];
    
nomes_da_matriz = strings(1, length(files));

for i = 1:length(files)
    
    nomeArquivo = files{i};
    
    % pega os 4 primeiros caracteres (sigla)
    sigla = extractBefore(nomeArquivo, '-');
    
    nomes_da_matriz(i) = sigla;

%     fid = fopen(files{i},'rt');
    arquivoCompleto = fullfile(pasta, files{i});
    fid = fopen(arquivoCompleto,'rt');
    if fid == -1
        error('Não foi possível abrir o arquivo: %s', arquivoCompleto);
    end
    raw = textscan(fid,'%s','Delimiter','\n','HeaderLines',1);
    fclose(fid);

    txt = raw{1};

    txt = strrep(txt,',','.');
    txt = strrep(txt,'-999.0','NaN');

    data = cellfun(@str2num,txt,'UniformOutput',false);
    data = cell2mat(data);

    media = data(:,1);

    vtec_data = data(:,5:2:end);
    
    vtec_data = [vtec_data(:,1); vtec_data(:,2); vtec_data(:,3); vtec_data(:,4); vtec_data(:,5); vtec_data(:,6);vtec_data(:,7); vtec_data(:,8); vtec_data(:,9); vtec_data(:,10);...
                 vtec_data(:,11); vtec_data(:,12); vtec_data(:,13); vtec_data(:,14); vtec_data(:,15); vtec_data(:,16);vtec_data(:,17); vtec_data(:,18); vtec_data(:,19); vtec_data(:,20);...
                 vtec_data(:,21); vtec_data(:,22); vtec_data(:,23); vtec_data(:,24); vtec_data(:,25); vtec_data(:,26);vtec_data(:,27); vtec_data(:,28); vtec_data(:,29); vtec_data(:,30);...
                 vtec_data(:,31)];

    media_expand = repmat(media,31,1);

    diffTEC = vtec_data - media_expand;

    idx = [];

    for d = dias_escolhidos
        inicio = (d-1)*horas_por_dia + 1;
        fim = d*horas_por_dia;
        idx = [idx inicio:fim];
    end

    matriz(:,i) = diffTEC(idx);

end

    % --- ALINHAMENTO COM O TXT ---

    [~, idx] = ismember(estacoes_ref, nomes_da_matriz);

    % Verificação de segurança
    if any(idx == 0)
        error('Tem estação no TXT que não existe nos arquivos!');
    end

    matriz = matriz(:, idx);
end