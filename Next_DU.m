// Função PRINCIPAL: Next_DU (versão corrigida)
(data as date, delta as number) as date =>
let
    // --- Funções auxiliares ---
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

    FeriadosNacionaisBR = (ano as number) as list =>
        let
            FeriadosFixos = {
                #date(ano, 1, 1),   // Ano Novo
                #date(ano, 4, 21),  // Tiradentes
                #date(ano, 5, 1),   // Dia do Trabalho (FERIADO EM 1/5/2025)
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

    IsDU = (data as date) as logical =>
        let
            DiaSemana = Date.DayOfWeek(data, Day.Monday),
            Feriado = List.Contains(FeriadosNacionaisBR(Date.Year(data)), data)
        in
            DiaSemana < 5 and not Feriado,  // 0=Segunda a 4=Sexta, não é feriado

    // --- Lógica principal ---
    // Passo 1: Avança/retrocede apenas dias úteis
    DataFinal = if delta > 0 then
                    List.Accumulate(
                        {1..delta},
                        data,
                        (currentDate, _) => 
                            let
                                ProximoDia = Date.AddDays(currentDate, 1),
                                DiaUtil = if IsDU(ProximoDia) then ProximoDia else @NextDU(ProximoDia)
                            in
                                DiaUtil
                    )
                else
                    List.Accumulate(
                        {1..Number.Abs(delta)},
                        data,
                        (currentDate, _) => 
                            let
                                DiaAnterior = Date.AddDays(currentDate, -1),
                                DiaUtil = if IsDU(DiaAnterior) then DiaAnterior else @LastDU(DiaAnterior)
                            in
                                DiaUtil
                    ),

    NextDU = (data as date) as date =>
        if IsDU(Date.AddDays(data, 1)) then 
            Date.AddDays(data, 1)
        else 
            @NextDU(Date.AddDays(data, 1)),

    LastDU = (data as date) as date =>
        if IsDU(Date.AddDays(data, -1)) then 
            Date.AddDays(data, -1)
        else 
            @LastDU(Date.AddDays(data, -1))
in
    DataFinal
