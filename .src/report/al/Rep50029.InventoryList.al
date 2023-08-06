report 50029 "SEI Physical Inventory List"
{
    DefaultLayout = RDLC;
    RDLCLayout = '.src/report/rdlc/Rep50029.PhysInventoryList1.rdlc';
    ApplicationArea = Warehouse;
    Caption = 'SEI Physical Inventory List';
    UsageCategory = ReportsAndAnalysis;

    dataset
    {

        dataitem("Company Information"; "Company Information")
        {
            column(Company_Name; "Company Information".Name) { }
        }

        dataitem("Item Journal Batch"; "Item Journal Batch")
        {
            RequestFilterFields = "Journal Template Name", Name;
            column(JBatchJournal_Template_Name; "Journal Template Name") { }
            column(JBatchName; Name) { }
            column(ShowLOTDetails; ShowLOTDetails) { }

            dataitem("Item Journal Line"; "Item Journal Line")
            {
                DataItemLink = "Journal Template Name" = field("Journal Template Name");
                column(JLineJournal_Template_Name; "Journal Template Name") { }
                column(Journal_Batch_Name; "Journal Batch Name") { }
                column(JLineItem_No_; "Item No.") { }
                column(JLinePosting_Date; "Posting Date") { }
                column(JLineDocument_No_; "Document No.") { }
                column(JLineDescription; Description) { }
                column(JLineLocation_Code; "Location Code") { }
                column(JLineBin_Code; "Bin Code") { }
                column(JLineQuantity__Base_; "Quantity (Base)") { }
                column(JLineQty___Calculated_; "Qty. (Calculated)") { }
                column(Unit_of_Measure_Code; "Unit of Measure Code") { }


                dataitem("Item Ledger Entry"; "Item Ledger Entry")
                {
                    DataItemLink = "Item No." = field("Item No.");

                    column(Item_No_; "Item No.") { }
                    column(Quantity__Base_; "Invoiced Quantity") { }
                    column(Location_Code; "Location Code") { }
                    column(Remaining_Quantity; "Remaining Quantity") { }

                    column(Lot_No_; "Lot No.") { }

                    trigger OnPreDataItem();
                    begin
                        "Item Ledger Entry".SetFilter("Location Code", InvLocationCode);
                        "Item Ledger Entry".SetFilter("Remaining Quantity", '>0');
                        //Azokat a lot számokat jeleníti meg, amelyeknél a remaining qty > 0 és az érintett rakrárban vannak
                    end;
                }

                trigger OnPreDataItem();
                begin
                    "Item Journal Line".SetRange("Item Journal Line"."Journal Batch Name", "Item Journal Batch".Name);
                    "Item Journal Line".SetFilter("Location Code", InvLocationCode);
                    //A leltár adatok 1 táblában vannak. Ez a szűrés azért kell, hogy csak az érintett raktár legyen a listán
                end;
            }
        }
    }

    requestpage
    {
        SaveValues = true;
        layout
        {
            area(Content)
            {
                group(Options)
                {
                    field(ShowLotDetails; ShowLOTDetails)
                    {
                        ApplicationArea = All;
                        Caption = 'Show LOT details';
                    }
                    field(InvLocationCode; InvLocationCode)
                    {
                        ApplicationArea = All;
                        Caption = 'Select location';
                        TableRelation = Location;
                    }
                }
            }
        }

    }
    labels
    {
        LblItemNumber = 'Item number';
        LblItemDesc = 'Description';
        LblLocation = 'Location';
        LblBin = 'Bin code';
        LblCalculatedQty = 'Quantity (Calculated)';
        LblPage = 'Page :';
        LblReportTitle = 'Inventory list';
        lblInvControlby = 'Inventory control by :';
        LblInvBy = 'Inventory by :';
        LblCountedQty = 'Counted qty';
        LblBatchName = 'Batch name :';
        LblJournalName = 'Journal name :';
        LblDocumentNo = 'Document number';
        LblDate = 'Date';
        LblUnit = 'Unit';

    }


    var
        ShowLOTDetails: Boolean;
        InvLocationCode: Code[10];
        SEILocations: Record Location;
        SEIItemJurnalLineSheetName: Code[10];


    trigger OnInitReport()
    begin
        ShowLOTDetails := true;
    end;

}