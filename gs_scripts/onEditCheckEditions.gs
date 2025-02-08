function onEdit(e) {
  // Verifica se o evento existe (para evitar erros ao executar manualmente)
  if (!e) return;

  var sheet = e.source.getActiveSheet();
  var range = e.range; // Identifica a célula que foi editada

  // Define as configurações padrão
  var defaultFont = "Nunito"; // Fonte desejada
  var defaultFontSize = 10;   // Tamanho da fonte
  var horizontalAlignment = "center"; // Alinhamento horizontal (centralizado)
  var verticalAlignment = "middle";   // Alinhamento vertical (meio)

  // Seleciona TODAS as células da planilha
  var allRange = sheet.getDataRange();

  // Aplica a formatação padrão em TODAS as células da planilha
  allRange.setFontFamily(defaultFont);
  allRange.setFontSize(defaultFontSize);
  allRange.setHorizontalAlignment(horizontalAlignment);
  allRange.setVerticalAlignment(verticalAlignment);
}