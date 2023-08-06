report 50025 "SEI Prod. Oder Statistic (Cap)"
{
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;
    Caption = 'Finished production order capacity statistic', Locked = true;
    DefaultLayout = RDLC;
    RDLCLayout = '.src/report/rdlc/Rep50025.report.ProdOrderStat.rdlc';

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
            column(LocationCode; LocationCode) { }

            dataitem("Prod. Order Routing Line"; "Prod. Order Routing Line")
            {
                DataItemLink = "Prod. Order No." = field("No.");
                column(Key_Routing_No_; "Routing No.") { }
                //column(Key_Routing_Reference_No_; "Routing Reference No.") { }
                column(Key_Operation_No_; "Operation No.") { }
                column(Prod__Order_No_; "Prod. Order No.") { }
                column(No_; "No.") { }
                column(Unit_Cost_per; "Unit Cost per") { }
                column(Input_Quantity; "Input Quantity") { }
                column(Run_Time; "Run Time") { }
                column(Starting_Date; "Starting Date") { }
                column(Ending_Date; "Ending Date") { }
                column(Status; Status) { }
                column(EstimatedOpCost; CalcEstimatedWorkCenterCost("Run Time", "Unit Cost per", "Input Quantity")) { }
                column(AllocatedTime; CalcAllocatedTime("Run Time", "Input Quantity")) { }
                column(ActualTimeSumm; ActualTimeSumm("Prod. Order No.", "No.", "Operation No.")) { }
                column(CalcActualCost; CalcActualCost(ActualTimeSumm("Prod. Order No.", "No.", "Operation No."), "Unit Cost per")) { }
            }


            trigger OnPreDataItem()
            begin
                "Production Order".SetRange(Status, "Production Order".Status::Finished);
                "Production Order".SetRange("Production Order"."Shortcut Dimension 1 Code", LocationCode);
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
                        TableRelation = "Dimension Value".Code where("Dimension Code" = const('DIVISION'));
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
        LblMachineName = 'Machine Center', Locked = true;
        LblEstimatedOperationCost = 'Planned Operation Cost', Locked = true;
        LblAllocatedTime = 'Planned Operation Time [WH]', Locked = true;
        LblActualCost = 'Actual Operation Cost', Locked = true;
        LblActualTime = 'Actual Operation Time [WH]', Locked = true;
        LblCostDifference = 'Cost Diff. [Plan - Actual]', Locked = true;
        LblTimeDifference = 'Time Diff. [Plan WH - Actual WH]', Locked = true;
        LblReportTitle = 'Production order statistic. Capacity cost of finished production.', Locked = true;
        LblPage = 'Page :', Locked = true;
        LblUser = 'User name :', Locked = true;
        LblPercentDiff = 'Difference in percentage', Locked = true;
        LblWOClosingDate = 'Finish date', Locked = true;
    }


    var
        StartingDate: DateTime;
        EndingDate: DateTime;
        LocationCode: Code[10];
        TableID: Code[10];
        ItemLedger: Record "Item Ledger Entry";
        CLERec: Record "Capacity Ledger Entry";

    local procedure CalcEstimatedWorkCenterCost(RunTime: Decimal; UnitCost: Decimal; InputQty: Decimal): Decimal
    begin
        exit(RunTime * UnitCost * InputQty)
    end;

    local procedure CalcAllocatedTime(RunTime: Decimal; InputQty: Decimal): Decimal
    begin
        exit(RunTime * InputQty)
    end;

    local procedure CalcActualCost(ActualTime: Decimal; UnitCost: Decimal): Decimal
    begin
        exit(ActualTime * UnitCost)
    end;

    local procedure CalcDiff(Actual: Decimal; Plan: Decimal): Decimal
    begin
        exit(Actual - Plan);
    end;

    local procedure ActualTimeSumm(ProdOrder: Code[20]; WorkCenter: Code[20]; OpNum: Code[20]): Decimal
    var
        ActualWorkTime: Decimal;

    begin
        ActualWorkTime := 0;
        CLERec.SetFilter("Document No.", "ProdOrder");
        CLERec.SetFilter("No.", WorkCenter);
        CLERec.SetFilter("Operation No.", OpNum);

        if CLERec.Find('-') then begin //megkeresi az első rekordot
            repeat // a ciklus hozzáadja az actual work time-hoz az értéket, addig megy amíg nem lesz másik rekord
                ActualWorkTime += CLERec.Quantity;
            until (CLERec.Next = 0);
        end;
        exit(ActualWorkTime);
    end;
}
