//----------------------------------------------------------
// MODELO MVC para Avaliação 
//----------------------------------------------------------
//Bibliotecas
#Include "Totvs.ch"
#Include "FWMVCDef.ch"

//Variveis Estaticas
Static cTitulo := "Tarefas"
Static cTabPai := "ZZG"
Static cTabFilho := "ZZH"

/*/{Protheus.doc} User Function TVS25
Tarefas
@author GUILHERME FERREIRA MENEZES
@since 10/06/2025
@version 1.0
@type User function 
U_TVS25()
/*/

User Function TVS25()
	Local aArea   := FWGetArea()
	Local oBrowse
	Private aRotina := {}

	//Definicao do menu
	aRotina := MenuDef()

	//Instanciando o browse
	oBrowse := FWMBrowse():New()
	oBrowse:SetAlias(cTabPai)
	oBrowse:SetDescription(cTitulo)
	oBrowse:DisableDetails()

	//Adicionando as Legendas
	oBrowse:AddLegend( "ZZG->ZZG_SITUAC=='3'", "VIOLET",    "Concluido" )
	oBrowse:AddLegend( "ZZG->ZZG_SITUAC=='1'", "BLUE",    	"Pendente" )
	oBrowse:AddLegend( "ZZG->ZZG_SITUAC=='2'", "GREEN",    	"Agendamento" )
	oBrowse:AddLegend( "ZZG->ZZG_SITUAC=='4'", "RED",    	"Cancelado" )

	//Ativa a Browse
	oBrowse:Activate()

	FWRestArea(aArea)
Return Nil

/*/{Protheus.doc} MenuDef
Menu de opcoes na funcao TVS25
@author GUILHERME FERREIRA MENEZES
@since 10/06/2025
@version 1.0
@type function
/*/

Static Function MenuDef()
	Local aRotina := {}

	//Adicionando opcoes do menu
	ADD OPTION aRotina TITLE "Visualizar" ACTION "VIEWDEF.TVS25" OPERATION 1 ACCESS 0
	ADD OPTION aRotina TITLE "Incluir" ACTION "VIEWDEF.TVS25" OPERATION 3 ACCESS 0
	ADD OPTION aRotina TITLE "Alterar" ACTION "VIEWDEF.TVS25" OPERATION 4 ACCESS 0
	ADD OPTION aRotina TITLE "Excluir" ACTION "VIEWDEF.TVS25" OPERATION 5 ACCESS 0
	ADD OPTION aRotina TITLE "Copiar" ACTION "VIEWDEF.TVS25" OPERATION 9 ACCESS 0

Return aRotina

/*/{Protheus.doc} ModelDef
Modelo de dados na funcao TVS25
@author GUILHERME FERREIRA MENEZES
@since 10/06/2025
@version 1.0
@type function
/*/

Static Function ModelDef()
	Local oStruPai := FWFormStruct(1, cTabPai)
	Local oStruFilho := FWFormStruct(1, cTabFilho)
	Local aRelation := {}
	Local oModel
	Local bPre := Nil
	Local bPos := { || TVSVLD() }
	Local bCancel := Nil


	//Cria o modelo de dados para cadastro
	oModel := MPFormModel():New("TVS25M", bPre, bPos, /*bCommit*/, bCancel)
	oModel:AddFields("ZZGMASTER", /*cOwner*/, oStruPai)
	oModel:AddGrid("ZZHDETAIL","ZZGMASTER",oStruFilho,/*bLinePre*/, /*bLinePost*/,/*bPre - Grid Inteiro*/,/*bPos - Grid Inteiro*/,/*bLoad - Carga do modelo manualmente*/)
	oModel:SetDescription("Gerenciador de Tarefas")
	oModel:GetModel("ZZGMASTER"):SetDescription( "Tarefa")
	oModel:GetModel("ZZHDETAIL"):SetDescription( "Subtarefas")
	oModel:SetPrimaryKey({})

	//Fazendo o relacionamentoX
	aAdd(aRelation, {"ZZH_FILIAL", "FWxFilial('ZZH')"} )
	aAdd(aRelation, {"ZZH_CODTAR", "ZZG_CODIGO"})
	oModel:SetRelation("ZZHDETAIL", aRelation, ZZH->(IndexKey(1)))

Return oModel

/*/{Protheus.doc} ViewDef
Visualizacao de dados na funcao TVS25
@author GUILHERME FERREIRA MENEZES
@since 10/06/2025
@version 1.0
@type function
/*/

Static Function ViewDef()
	Local oModel := FWLoadModel("TVS25")
	Local oStruPai := FWFormStruct(2, cTabPai)
	Local oStruFilho := FWFormStruct(2, cTabFilho)
	Local oView

	//Cria a visualizacao do cadastro
	oView := FWFormView():New()
	oView:SetModel(oModel)
	oView:AddField("VIEW_ZZG", oStruPai, "ZZGMASTER")
	oView:AddGrid("VIEW_ZZH",  oStruFilho,  "ZZHDETAIL")

	//Partes da tela
	oView:CreateHorizontalBox("CABEC", 30)
	oView:CreateHorizontalBox("GRID", 70)
	oView:SetOwnerView("VIEW_ZZG", "CABEC")
	oView:SetOwnerView("VIEW_ZZH", "GRID")

	//Titulos das Grids
	oView:EnableTitleView("VIEW_ZZG", "Tarefas")
	oView:EnableTitleView("VIEW_ZZH", "Subtarefas")

	//Adicionando campo incremental na grid
	//oView:AddIncrementField("VIEW_ZZH", "ZZH_CODIGO")

	//Adicionando as Legendas
	/*oView:AddLegend( "ZZH->ZZH_STATUS=='3'", "VIOLET",	"Concluido" )
	oView:AddLegend( "ZZH->ZZH_STATUS=='1'", "BLUE",	"Pendente" )
	oView:AddLegend( "ZZH->ZZH_STATUS=='2'", "GREEN",	"Agendamento" )
	oView:AddLegend( "ZZH->ZZH_STATUS=='4'", "RED",    	"Cancelado" )*/
Return oView


// Função utilizada para testes individuais das tabelas
User Function IniTsk()
    Local aArea    := GetArea()
    Local aAreaB1  := ZZG->(GetArea())
    Local cDelOk   := ".T."
    Local cFunTOk  := ".T." 
 
    //Chamando a tela de cadastros
    AxCadastro('ZZG', 'Tarefas', cDelOk, cFunTOk)
 
    RestArea(aAreaB1)
    RestArea(aArea)
Return

User Function IniSub()
    Local aArea    := GetArea()
    Local aAreaB1  := ZZH->(GetArea())
    Local cDelOk   := ".T."
    Local cFunTOk  := ".T."
 
    //Chamando a tela de cadastros
    AxCadastro('ZZH', 'Sub-Tarefas', cDelOk, cFunTOk)
 
    RestArea(aAreaB1)
    RestArea(aArea)
Return

/*/{Protheus.doc} TVSVLD
Função executada após a gravação no cadastro da TVS25
@type function
@since 10/06/2025
@author GUILHERME FERREIRA MENEZES
@version 1.0
/*/
Static Function TVSVLD()
	Local cCodTar := IIF(Empty(M->ZZG_CODIGO), ZZG->ZZG_CODIGO, M->ZZG_CODIGO)
	Local lTemPendAgend := .F.
	Local lOk := .T.
	Local dHoje := Date()

	// Vai para a primeira subtarefa da Tarefa
	DbSelectArea("ZZH")
	DbSetOrder(2) //índice FILIAL+ZZH_CODTAR
	DbSeek(xFilial("ZZH") + cCodTar)

	While !Eof() .And. ZZH->ZZH_CODTAR == cCodTar

			// Regra 2: Subtarefa com status 3 deve ter data de conclusão
	If ZZH->ZZH_STATUS == '3' .And. Empty(ZZH->ZZH_DTCONC)
		// Mensagem informativa com confirmação
		If  MsgYesNo("Subtarefa concluída sem data de conclusão." + CRLF + ;
					"Deseja marcar como concluída hoje?")
			DbSelectArea("ZZH")
			DbSetOrder(1) // índice: FILIAL+CODTAR ou similar
			If DbSeek(xFilial("ZZH") + ZZH->ZZH_CODIGO)
				RecLock("ZZH", .F.)
				ZZH->ZZH_STATUS := '3'
				ZZH->ZZH_DTCONC := Date()
				MsUnlock()
			EndIf
		Else
			// Usuário optou por não completar, então retorna erro
			Alert("Operação cancelada. Preencha a data de conclusão manualmente.")
			Return .F.
		EndIf
	EndIf

		DbSkip()
	EndDo
		
		// Regra 3: Se tem data futura, forçar status 2
		If !Empty(ZZH->ZZH_DTCONC) .And. ZZH->ZZH_DTCONC > dHoje
			RecLock("ZZH", .F.)
			ZZH->ZZH_STATUS := '2'
			MsUnlock()
		EndIf

		// Verifica se ainda existem subtarefas pendentes ou agendadas
		If ZZH->ZZH_STATUS == '1' .Or. ZZH->ZZH_STATUS == '2'
			lTemPendAgend := .T.
		EndIf

		DbSkip()
	// Regra 1: Se não há pendente nem agendamento, definir tarefa como concluída
	If !lTemPendAgend
		DbSelectArea("ZZG")
		If DbSeek(xFilial("ZZG") + cCodTar)
			RecLock("ZZG", .F.)
			ZZG->ZZG_SITUAC := '3'
			ZZG->ZZG_DTCONC := DATE()
			MsUnlock()
		EndIf
	EndIf

	/*If lOk
		Alert("OK")
	EndIf*/

Return lOk
