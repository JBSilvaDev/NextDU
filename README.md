# Função `NextDU` para Cálculo de Dias Úteis em Power Query (M)

## 📌 Visão Geral
Esta função calcula uma data futura ou passada com base em um número de dias úteis (úteis), considerando:
- **Finais de semana** (sábados e domingos)
- **Feriados nacionais brasileiros** (fixos e móveis como Carnaval, Páscoa, etc.)

Foi desenvolvida para uso no **Power BI**, **Excel** e outras ferramentas que utilizam a linguagem **Power Query (M)**.

## 🚀 Como Usar
### Sintaxe Básica
```powerquery
DeltaDU(data_inicial as date, dias_uteis as number) as date
```

### Exemplos
```powerquery
// Avançar 6 dias úteis a partir de 1º de Maio de 2025
DeltaDU(#date(2025, 5, 1), 6)  // Retorna 9/5/2025

// Retroceder 3 dias úteis
DeltaDU(#date(2025, 5, 8), -3)  // Retorna 2/5/2025
```

## 📅 Feriados Considerados
A função inclui automaticamente todos os feriados nacionais brasileiros:
- **Feriados fixos**: 
  - 1/1 (Ano Novo), 21/4 (Tiradentes), 1/5 (Dia do Trabalho), etc.
- **Feriados móveis** (baseados na Páscoa):
  - Carnaval, Sexta-Feira Santa, Corpus Christi

> ℹ️ **Nota:** Feriados estaduais/municipais não estão incluídos por padrão.

## ⚙️ Implementação Técnica
### Lógica Principal
1. Verifica se a data inicial é dia útil
2. Avança/retrocede dia a dia, pulando finais de semana e feriados
3. Usa recursão para encontrar o próximo/último dia útil quando necessário

### Funções Auxiliares
- `IsDU()`: Verifica se uma data é dia útil
- `NextDU()`: Encontra o próximo dia útil
- `LastDU()`: Encontra o último dia útil
- `CalculaPascoa()`: Implementa o algoritmo de Meeus/Jones/Butcher
- `FeriadosNacionaisBR()`: Lista completa de feriados

## 💻 Como Adicionar ao Seu Projeto
1. No Power BI/Excel:
   - Acesse o Editor do Power Query
   - Crie uma nova consulta em branco
   - Cole todo o código da função
   - Renomeie a consulta para `DeltaDU`

2. Use em suas fórmulas:
   ```powerquery
   // Em uma coluna personalizada:
   = Table.AddColumn(Tabela, "Nova Data", each DeltaDU([Data], 5), type date)
   ```

## 📝 Observações Importantes
1. **Performance**: Para grandes volumes de dados, considere pré-calcular dias úteis
2. **Atualizações**: Feriados novos (como Consciência Negra) podem precisar de ajustes
3. **Finais de semana**: Considera sábado e domingo como não-úteis

## 📜 Licença
MIT License - Livre para uso e modificação

---

**Contribuições são bem-vindas!**  
Encontrou um bug ou tem uma melhoria? Abra uma issue ou pull request no GitHub.
