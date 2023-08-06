report 50026 "SEI Prod. Oder Statistic (RAW)"
{
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;
    Caption = 'Finished production order raw mat. statistic', Locked = true;
    DefaultLayout = RDLC;
    RDLCLayout = '.src/report/rdlc/Rep50026.report.ProdOrderStat.rdlc';

    dataset
    {
        dataitem("Production Order"; "Production Order")
        {
            column(WONumber; "No.") { }
            column(SEI_First_Capacity_Entry_Date; "SEI First Capacity Entry Date") { }
            column(SEI_Last_Capacity_Entry_Date; "SEI Last Capacity Entry Date") { }
            column(SEI_Finished_DateTime; "SEI Finished DateTime") { }
            column(StartingDate; StartingDate) { }
            column(EndingDate; EndingDate) { }

            dataitem("Prod. Order Component"; "Prod. Order Component")
            {
                DataItemLink = "Prod. Order No." = field("No.");
                column(Prod__Order_No_; "Prod. Order No.") { }
                column(RMItem_No_; "Item No.") { }
                column(RMDescription; Description) { }
                column(RMExpected_Quantity; "Expected Quantity") { }
                column(RMRemaining_Quantity; "Remaining Quantity") { }
                column(RMCost_Amount; "Cost Amount") { }
                column(RMUnit_Cost; "Unit Cost") { }
                column(RMLocationCode; LocationCode) { }
                column(RMUnit_of_Measure_Code; "Unit of Measure Code") { }
                column(SumConsumption; SumConsumption("Prod. Order No.", "Item No.")) { }
                column(SumCostOfConsumption; SumConsumption("Prod. Order No.", "Item No.") * "Unit Cost") { }
            }
            trigger OnPreDataItem()
            begin
                "Production Order".SetRange(Status, "Production Order".Status::Finished);
                "Production Order".SetRange("Production Order"."Location Code", LocationCode);
                "Production Order".SetRange("Production Order"."SEI Finished DateTime", StartingDate, EndingDate);

            end;

        }

    }
    requestpage
    {
        SaveValues = true;
        layout
        {
            area(Content)
            {
                group("Select filters")
                {
                    Caption = 'Basic filter data';
                    field(Starting; StartingDate)
                    {

                        ApplicationArea = All;
                        Caption = 'Start date', Locked = true;
                        //TableRelation = "Prod. Order Routing Line"."Ending Date";


                    }
                    field(Ending; EndingDate)
                    {

                        ApplicationArea = All;
                        Caption = 'End date', Locked = true;
                        //TableRelation = "Prod. Order Routing Line"."Ending Date";

                    }
                    field(Location; LocationCode)
                    {

                        ApplicationArea = All;
                        Caption = 'Location', Locked = true;
                        TableRelation = Location.Code;
                    }

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
        LblWONumber = 'Work Order No', Locked = true;
        LblRMItemNumber = 'Raw Material Item', Locked = true;
        LblRMDesc = 'Raw material description', Locked = true;
        LblRMPlannedCost = 'Raw material planned cost', Locked = true;
        LblRMActualCost = 'Raw material actual cost', Locked = true;
        LblRMPlanQty = 'Plan qty.', Locked = true;
        LblRMActQty = 'Act. qty.', Locked = true;
        LblCostDifference = 'Cost Diff. [Plan - Actual]', Locked = true;
        LblTimeDifference = 'Time Diff. [Plan WH + Actual WH]', Locked = true;
        LblReportTitle = 'Production order statistic. RAW material cost of finished production.', Locked = true;
        LblPage = 'Page :', Locked = true;
        LblUser = 'User name :', Locked = true;
        LblUnit = 'Unit', Locked = true;
        LblQtyDiff = 'Qty. Diff. [Plan + Actual]', Locked = true;
    }


    var
        StartingDate: DateTime;
        EndingDate: DateTime;
        LocationCode: Code[10];
        ItemLegder: Record "Item Ledger Entry";

    local procedure SumConsumption(ProdOrder: Code[20]; Item: Code[20]): Decimal
    var
        SummValue: Decimal;
    begin
        SummValue := 0;
        ItemLegder.SetFilter("Document No.", ProdOrder);
        ItemLegder.SetFilter("Item No.", Item);
        ItemLegder.SetRange("Entry Type", ItemLegder."Entry Type"::Consumption);

        if ItemLegder.Find('-') then begin //megkeresi az első rekordot
            repeat // a ciklus hozzáadja az actual work time-hoz az értéket, addig megy amíg nem lesz másik rekord
                SummValue += ItemLegder.Quantity;
            until (ItemLegder.Next = 0);
        end;
        exit(SummValue);
    end;
}
