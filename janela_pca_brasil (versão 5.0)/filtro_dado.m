function [matriz, siglas_encontradas] = filtrar_e_gerar_matriz(pasta, ano_digitado, dias_escolhidos, estacoes_ref)
    % 1. Converte o ano para string para usar no filtro de busca
    ano_str = num2str(ano_digitado);
    
    % 2. Busca arquivos que contenham o ano no nome (ex: *2023*.txt)
    filtro = fullfile(pasta, ['*', ano_str, '*.txt']);
    files_struct = dir(filtro);
    
    if isempty(files_struct)
        error('Nenhum arquivo encontrado para o ano %s na pasta selecionada.', ano_str);
    end
    
    files = {files_struct.name};
    horas_por_dia = 1440;
    temp_matriz = [];
    siglas_lidas = strings(1, length(files));

    % 3. Loop de leitura (mesma lógica que você já usa)
    for i = 1:length(files)
        nomeArquivo = files{i};
        sigla = extractBefore(nomeArquivo, '-'); % Pega a sigla antes do primeiro '-'
        siglas_lidas(i) = sigla;

        arquivoCompleto = fullfile(pasta, nomeArquivo);
        fid = fopen(arquivoCompleto,'rt');
        raw = textscan(fid,'%s','Delimiter','\n','HeaderLines',1);
        fclose(fid);

        txt = strrep(raw{1}, ',', '.');
        txt = strrep(txt, '-999.0', 'NaN');
        data = cell2mat(cellfun(@str2num, txt, 'UniformOutput', false));

        % Processamento do VTEC (sua lógica de 31 colunas)
        vtec_raw = data(:, 5:2:end);
        vtec_vector = vtec_raw(:); % Transforma em vetor coluna único
        
        media_expand = repmat(data(:,1), size(vtec_raw, 2), 1);
        diffTEC = vtec_vector - media_expand;

        % Filtro dos dias
        idx_tempo = [];
        for d = dias_escolhidos
            inicio = (d-1)*horas_por_dia + 1;
            fim = d*horas_por_dia;
            idx_tempo = [idx_tempo, inicio:fim];
        end
        
        temp_matriz(:, i) = diffTEC(idx_tempo);
    end

    % 4. O FILTRO CRÍTICO: Alinhamento com as coordenadas
    % Aqui verificamos quais siglas da referência existem nos arquivos do ano X
    [presente, idx_na_leitura] = ismember(estacoes_ref, siglas_lidas);
    
    % A matriz final só terá as colunas das estações que existem e estão na ordem correta
    matriz = temp_matriz(:, idx_na_leitura(presente));
    siglas_encontradas = estacoes_ref(presente);
end