//Cikkátsorolási és selejtezési jegyzőkönyv
report 50027 "SEI Invetory Posting Document"
{
    Caption = 'SEI Invetory Posting Document', Locked = true;

    ApplicationArea = All;
    UsageCategory = ReportsAndAnalysis;
    DefaultLayout = RDLC; //RDLC VS megnyitása csakkor lesz jó, ha van adatforrás
    RDLCLayout = '.src/report/rdlc/Rep50027.InvPostingDoc.rdlc';

    dataset
    {
        dataitem("Company Information"; "Company Information")
        {
            column(CmpInfoAddress; Address) { }
            column(CmpInfoCity; City) { }
            column(CMPInfoVAT_Registration_No_; "VAT Registration No.") { }
            column(CMPInfoPost_Code; "Post Code") { }
            column(CmpInfoName; Name) { }
        }
        // dataitem("Item Journal Template"; "Item Journal Template") // Naplólapok adatbázisa
        // {
        //     RequestFilterFields = Name;
        //     column(JurnalPageNo__Series; "No. Series") { }
        //     //column(JurnalPageTemplate_Type; "Template Type") { }
        //     column(JurnalPageName; Name) { }
        //     //column(Journal_Template_Name; "Journal Template Name") { }

        dataitem("Item Jurnal Line"; "Item Journal Line") // Naplólapokon lévő tételek adatbázisa
        {
            RequestFilterFields = "Journal Template Name", "Journal Batch Name";
            //DataItemLink = "Journal Batch Name" = field("Name");
            column(JLineJournal_Batch_Name; "Journal Batch Name") { }
            column(JLineJournal_Template_Name; "Journal Template Name") { }
            column(JLineItem_No_; "Item No.") { }
            column(JLineDescription; Description) { }
            column(JLinePosting_Date; "Posting Date") { }
            column(JLineEntry_Type; "Entry Type") { }
            column(JLineQuantity; Quantity) { }
            column(JLineUnit_Cost; "Unit Cost") { }
            column(JLineUnit_of_Measure_Code; "Unit of Measure Code") { }
            column(JLineTTLAmount; Quantity * "Unit Cost") { }
            column(JLineLine_No_; "Line No." / 10000) { }
            column(JLineLocation_Code; "Location Code") { }
            column(JLineDocument_No_; "Document No.") { }

            trigger OnPreDataItem()
            begin
                //"Item Journal Template".SetRange(Name, "Item Journal Template"."Name");
            end;
        }
        //}
    }

    requestpage
    {
        SaveValues = true;
        layout
        {
            area(Content)
            {
                group(GroupName)
                {
                    // field(Name; SourceExpression)
                    // {
                    //     ApplicationArea = All;

                    // }
                }
            }
        }

        actions
        {
            area(processing)
            {
                action(ActionName)
                {
                    ApplicationArea = All;

                }
            }
        }
    }

    labels
    {
        LblReportTitleMaterialMovement = 'Stock Movement Proof', Locked = true;
        LblReportTitleSrap = 'Inventory Disposal Proof', Locked = true;
        LblAdditionalTextForScrap = 'The committee confirms that the present receipt contains estimated costs and that they will be corrected after accounting.', Locked = true;
        LblCompanyName = 'Company name ', Locked = true;
        LblCompanyAddr = 'Company address ', Locked = true;
        LblCompanyTaxNr = 'TAX number ', Locked = true;
        LblReason = 'Reason ', Locked = true;
        LblMemberofCommittee = 'Members of committee ', Locked = true;
        LblLineNumber = 'Entry number', Locked = true;
        LblItemNumber = 'Item number', Locked = true;
        LblDescription = 'Desctription', Locked = true;
        LblLocation = 'Location', Locked = true;
        LblUnitOfMeasure = 'Unit', Locked = true;
        LblEstimatedUnitCost = 'Estimated unit cost', Locked = true;
        LblQuantity = 'Quantity', Locked = true;
        LblEstimatedTotalCost = 'Estimated cost', Locked = true;
        LblBookingDate = 'Booking date ', Locked = true;
        LblNumberOfDocument = 'Document number ', Locked = true;
        LblTTLLine = 'Totals (quantity, cost (estimation) ', Locked = true;
        LblApprovalLeader = 'Approval leader', Locked = true;
        LblSign = 'Signature', Locked = true;
        LblName = 'Name', Locked = true;
        LblPage = 'Page ', Locked = true;
        LblLine = 'Line', Locked = true;
    }


    var
        myInt: Integer;

    // [EventSubscriber(ObjectType::Codeunit, Codeunit::ReportManagement, 'OnAfterSubstituteReport', '', false, false)]
    // local procedure OnSubstituteReport(ReportId: Integer; var NewReportId: Integer)
    // begin
    //     if ReportId = Report::"Inventory Movement" then NewReportId := Report::"SEI Invetory Posting Document";
    // end;
}
