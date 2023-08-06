report 50096 "SEI MH Followup"
{
    DefaultLayout = RDLC;
    RDLCLayout = '.src/report/rdlc/rep50096.MHFollowup.rdlc';
    Caption = 'SEI MH Followup';
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;

    dataset
    {
        dataitem("Capacity Ledger Entry"; "Capacity Ledger Entry")
        {
            column(Workcenter; "No.") { }
            column(Item_No_; "Item No.") { }
            column(Run_Time; "Run Time") { }
            column(Direct_Cost; "Direct Cost") { }
            column(Output_Quantity; "Output Quantity") { }
            column(Location; "Global Dimension 1 Code") { }
            column(Document_Date; "Document Date") { }
            column(Routing_No_; "Routing No.") { }
            column(Routing_Reference_No_; "Routing Reference No.") { }
            column(Operation_No_; "Operation No.") { }
            column(StartingDate; StartingDate) { }
            column(EndingDate; EndingDate) { }
            column(LocationCode; LocationCode) { }
            column(Variant_Code; "Variant Code") { }
            column(Scrap_Quantity; "Scrap Quantity") { }
            column(Planned_run_time; GetStandardHour("Routing No.", "Variant Code", "Operation No.") * "Output Quantity") { }
            column(Planned_run_time_Cost; GetStandardHour("Routing No.", "Variant Code", "Operation No.") * GetWorkcenterCost("No.") * "Output Quantity") { }

            trigger OnPreDataItem()
            begin
                "Capacity Ledger Entry".SetRange("Capacity Ledger Entry"."Global Dimension 1 Code", LocationCode);
                "Capacity Ledger Entry".SetRange("Capacity Ledger Entry"."Document Date", StartingDate, EndingDate);
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
    }

    labels
    {
        LblTitle = 'MH Follow up report', Locked = true;
        LblPlannedRunTime = 'Planned run time (SH)', Locked = true;
        LblActualRunTime = 'Actual run time (WH)', Locked = true;
        LblRunTimeDiff = 'Run time diff.', Locked = true;
        LblPlannedRunTimeCost = 'Planned run time cost.', Locked = true;
        LblActualRunTimeCost = 'Actual run time cost.', Locked = true;
        LblCostDifference = 'Cost diff.', Locked = true;



    }

    var
        StartingDate: Date;
        EndingDate: Date;
        LocationCode: Code[10];
        RoutingRecord: Record "Routing Line";
        Machines: Record "Machine Center";

    local procedure GetStandardHour(Routing: Code[20]; VersionCode: Code[20]; OperationNumber: Code[10]): Decimal
    begin
        if RoutingRecord.Get(Routing, VersionCode, OperationNumber) then begin
            RoutingRecord.Init();
            RoutingRecord.Get(Routing, VersionCode, OperationNumber);
            exit(RoutingRecord."Run Time");
        end else begin
            exit(0);
        end;
    end;

    local procedure GetWorkcenterCost(Machine: Code[20]): Decimal
    begin
        Machines.Init();
        if Machines.Get(Machine) then begin
            exit(Machines."Direct Unit Cost");
        end;
    end;
}

