// Função DeltaDU corrigida
(data as date, delta as number) as date =>
let
    // ========== FUNÇÕES AUXILIARES ==========
    // Calcula a data da Páscoa (algoritmo de Meeus/Jones/Butcher)
    CalculaPascoa = (ano as number) as date =>
        let
            a = Number.Mod(ano, 19),
            b = Number.IntegerDivide(ano, 100),
            c = Number.Mod(ano, 100),
            d = Number.IntegerDivide(b, 4),
            e = Number.Mod(b, 4),
            f = Number.IntegerDivide(b + 8, 25),
            g = Number.IntegerDivide(b - f + 1, 3),
            h = Number.Mod(19*a + b - d - g + 15, 30),
            i = Number.IntegerDivide(c, 4),
            k = Number.Mod(c, 4),
            l = Number.Mod(32 + 2*e + 2*i - h - k, 7),
            m = Number.IntegerDivide(a + 11*h + 22*l, 451),
            mes = Number.IntegerDivide(h + l - 7*m + 114, 31),
            dia = Number.Mod(h + l - 7*m + 114, 31) + 1
        in
            #date(ano, mes, dia),

    // Lista de feriados brasileiros
    FeriadosNacionaisBR = (ano as number) as list =>
        let
            FeriadosFixos = {
                #date(ano, 1, 1),   // Ano Novo
                #date(ano, 4, 21),  // Tiradentes
                #date(ano, 5, 1),   // Dia do Trabalho
                #date(ano, 9, 7),   // Independência
                #date(ano, 10, 12), // Nossa Senhora Aparecida
                #date(ano, 11, 2),  // Finados
                #date(ano, 11, 15), // Proclamação da República
                #date(ano, 12, 25)  // Natal
            },
            Pascoa = CalculaPascoa(ano),
            FeriadosMoveis = {
                Date.AddDays(Pascoa, -48), // Segunda de Carnaval
                Date.AddDays(Pascoa, -47), // Terça de Carnaval
                Date.AddDays(Pascoa, -2),  // Sexta-feira Santa
                Pascoa,                   // Domingo de Páscoa
                Date.AddDays(Pascoa, 60)  // Corpus Christi
            },
            TodosFeriados = List.Combine({FeriadosFixos, FeriadosMoveis})
        in
            TodosFeriados,

    // Verifica se é dia útil
    IsDU = (data as date) as logical =>
        let
            diaSemana = Date.DayOfWeek(data, Day.Monday),
            naoFeriado = not List.Contains(FeriadosNacionaisBR(Date.Year(data)), data)
        in
            diaSemana < 5 and naoFeriado,

    // ========== LÓGICA PRINCIPAL ==========
    // Função para avançar 1 dia útil
    Avancar1DiaUtil = (currentDate as date) as date =>
        let
            proximoDia = Date.AddDays(currentDate, 1),
            resultado = if IsDU(proximoDia) then proximoDia else @Avancar1DiaUtil(proximoDia)
        in
            resultado,

    // Calcula a data final
    DataFinal = if delta = 0 then data
                else if delta > 0 then
                    List.Accumulate(
                        {1..delta},
                        data,
                        (state, _) => Avancar1DiaUtil(state))
                else
                    let
                        Retroceder1DiaUtil = (currentDate as date) as date =>
                            let
                                diaAnterior = Date.AddDays(currentDate, -1),
                                resultado = if IsDU(diaAnterior) then diaAnterior else @Retroceder1DiaUtil(diaAnterior)
                            in
                                resultado
                    in
                        List.Accumulate(
                            {1..Number.Abs(delta)},
                            data,
                            (state, _) => Retroceder1DiaUtil(state))
in
    DataFinal
