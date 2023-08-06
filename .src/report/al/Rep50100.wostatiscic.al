//Temporary-ben az önnállóan futtatható verzió van.
report 50100 "SEI Production order statistic"
{
    Caption = 'Gyártási rendelés statisztika';
    ApplicationArea = All;
    UsageCategory = ReportsAndAnalysis;
    DefaultLayout = RDLC;
    RDLCLayout = '.src/report/rdlc/rep50100wostatistic.rdlc';

    dataset
    {
        dataitem("Production Order"; "Production Order")
        //Ha formról indítható reportról van szó akkor minden esetben a főtáblától kell kezdeni az adatok gyűjtését, mert hibára fog futni.
        //itt a production order táblából nem kell adat ugyan, de a form ide adja át a WO-számot.
        {
            column(No_; "No.") { }
            column(Status; Status) { }
            dataitem("Prod. Order Component"; "Prod. Order Component")
            {
                DataItemLink = "Prod. Order No." = field("No.");
                column(RMProd__Order_No_; "Prod. Order No.") { }
                column(RMQuantity_per; "Quantity per") { }
                column(RMItem_No_; "Item No.") { }
                column(RMRemainingQty; "Remaining Quantity") { }
                column(RMExeptedQty; "Expected Quantity") { }
                column(RMUnit_of_Measure_Code; "Unit of Measure Code") { }

                dataitem("Prod. Order Line"; "Prod. Order Line")
                {
                    DataItemLink = "Prod. Order No." = field("Prod. Order No.");
                    column(Prod__Order_No_; "Prod. Order No.") { }
                    column(Finished_Quantity; "Finished Quantity") { }
                    column(WOLineItem_No_; "Item No.") { }
                    column(WOLineLocation_Code; "Location Code") { }
                    column(WOLineQuantity; Quantity) { }
                    column(WODescription; Description) { }
                    column(WOLineQty__per_Unit_of_Measure; "Qty. per Unit of Measure") { }
                    column(WOLineRemaining_Quantity; "Remaining Quantity") { }


                    dataitem("Company Information"; "Company Information")
                    {
                        column(CompanyName; Name) { }
                    }


                }
                trigger OnPostDataItem()
                begin
                    ILEWONumber := "Prod. Order Component"."Prod. Order No.";
                end;

                trigger OnPreDataItem()
                begin
                    //"Prod. Order Component".SetRange("Prod. Order Component"."Prod. Order No.", WONumber);

                end;
            }
        }
        dataitem("Item Ledger Entry"; "Item Ledger Entry")
        {
            //DataItemLink = "Document No." = field("Prod. Order No.");
            column(KeyEntry_No_; "Entry No.") { }
            column(Item_No_; "Item No.") { }
            column(Document_No_; "Document No.") { }
            column(Quantity; Quantity) { }
            column(Entry_Type; "Entry Type") { }
            column(OutputSumm; SumOutput("Item Ledger Entry")) { }
            column(ConsumptionSumm; SumConsumption("Item Ledger Entry")) { }
            column(ILEUnit_of_Measure_Code; "Unit of Measure Code") { }
            column(Lot_No_; "Lot No.") { }
            trigger OnPreDataItem()
            begin
                "Item Ledger Entry".SetRange("Item Ledger Entry"."Document No.", ILEWONumber);

                //"Item Ledger Entry".SetRange("Item Ledger Entry"."Entry Type", "Item Ledger Entry"."Entry Type"::Consumption);

            end;
        }//ile
        dataitem("Capacity Ledger Entry"; "Capacity Ledger Entry")
        {
            column(CLENo_; "No.") { }
            column(CLEQuantity; Quantity) { }
            column(CLEDocument_No_; "Document No.") { }
            column(CheckRunTime; CheckRunTime("Quantity", "No.")) { }

            trigger OnPreDataItem()
            begin
                "Capacity Ledger Entry".SetRange("Document No.", ILEWONumber);
            end;
        }

    } //dataset

    requestpage
    {
        layout
        {
            // area(content)
            // {
            //     group(GroupName)
            //     {
            //         Caption = 'Select workorder number';
            //         field(WONumber; WONumber)
            //         {
            //             TableRelation = "Production Order"."No." WHERE(Status = CONST(Released));

            //             ApplicationArea = All;
            //             Caption = 'Select workorder number';
            //         }
            //     }
            // }
        }
        actions
        {
            area(processing)
            {
            }
        }
    }//requestpage

    labels
    {
        LblWONumber = 'Select work order number.';
        LblWorkOrderNumber = 'Work order';
        LblConsumptedItemNo = 'RM Item number';
        LblEntryType = 'Entry type';
        LblQty = 'Quantity';
        LblQtyPer = 'BOM unit quantity';
        LblRequiredConsumption = 'Calculated consumption';
        LblItemLegdgerEntry = 'Real consumption';
        LblEstimatedConsumption = 'Estimated consumption';
        LblActualConsuption = 'Actual consumption';
        LblLocationCode = 'Location';
        LblWOItemNumber = 'Produce item';
        LblWOQty = 'Quantity';
        LblWOFinishedQty = 'Finished Qty.';
        LblWODescription = 'Description';
        LblUnitCode = 'Unit of measure';
        LblWORemainingQty = 'Rem. qty.';
        LblTitle = 'Raw material consumption statistic of workorder';
        LblStatus = 'Status';
        LblRunTimeCheck = 'Run time booking warning!';


    }//labels

    var
        ILEWONumber, WONumber : Code[20];

    local procedure SumOutput(var EntryType: Record "Item Ledger Entry"): Decimal
    var
        SummValue: Decimal;
    begin
        if (EntryType."Entry Type" = EntryType."Entry Type"::Output)
        then begin
            SummValue := SummValue + (EntryType.Quantity);
            exit(SummValue);
        end else begin
            SummValue := SummValue + EntryType.Quantity;
            exit(SummValue);
        end;
    end;

    local procedure SumConsumption(var EntryType: Record "Item Ledger Entry"): Decimal
    var
        SummValue: Decimal;
    begin
        if (EntryType."Entry Type" = EntryType."Entry Type"::Consumption) and (EntryType."Unit of Measure Code" = 'PC')
        then begin
            SummValue := SummValue + EntryType.Quantity;
            exit(SummValue / 1000);
        end else begin
            SummValue := SummValue + EntryType.Quantity;
            exit(SummValue);
        end;
    end;

    local procedure CheckRunTime(RunTime: Decimal; WorkCenter: Code[20]): Text
    begin
        if (RunTime > 7.33) then
            exit('Wrong run time booking! :' + ' ' + WorkCenter + ' ' + Format(RunTime))
        else
            exit('');

    end;

}
