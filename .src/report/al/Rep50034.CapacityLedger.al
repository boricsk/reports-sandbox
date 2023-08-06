report 50034 "SEI Capacity Ledger Entry"
{
    DefaultLayout = RDLC;
    RDLCLayout = '.src/report/rdlc/Rep50034.CapacityLedgerEntry.rdlc';
    ApplicationArea = All;
    Caption = 'SEI Capacity Ledger Entry';
    UsageCategory = ReportsAndAnalysis;

    dataset
    {
        dataitem("Capacity Ledger Entry"; "Capacity Ledger Entry")
        {
            column(Entry_No_; "Entry No.") { }
            column(No_; "No.") { }
            column(Posting_Date; "Posting Date") { }
            column(Document_No_; "Document No.") { }
            column(Description; Description) { }
            column(Operation_No_; "Operation No.") { }
            column(Work_Center_No_; "Work Center No.") { }
            column(Quantity; Quantity) { }
            column(Setup_Time; "Setup Time") { }
            column(Run_Time; "Run Time") { }
            column(Stop_Time; "Stop Time") { }
            column(Invoiced_Quantity; "Invoiced Quantity") { }
            column(Output_Quantity; "Output Quantity") { }
            column(Scrap_Quantity; "Scrap Quantity") { }
            column(Cap__Unit_of_Measure_Code; "Cap. Unit of Measure Code") { }
            column(Qty__per_Cap__Unit_of_Measure; "Qty. per Cap. Unit of Measure") { }
            column(Global_Dimension_1_Code; "Global Dimension 1 Code") { }
            column(Global_Dimension_2_Code; "Global Dimension 2 Code") { }
            column(Starting_Time; "Starting Time") { }
            column(Ending_Time; "Ending Time") { }
            column(GetStartTime; GetStartTime("Entry No.")) { }
            column(GetFinishTime; GetFinishTime("Entry No.")) { }
            column(CalcDuraation; CalcDuraation("Starting Time", "Ending Time")) { }
            column(Routing_No_; "Routing No.") { }
            column(Item_No_; "Item No.") { }
            column(Unit_of_Measure_Code; "Unit of Measure Code") { }
            column(Qty__per_Unit_of_Measure; "Qty. per Unit of Measure") { }
            column(Document_Date; "Document Date") { }
            column(External_Document_No_; "External Document No.") { }
            column(Stop_Code; "Stop Code") { }
            column(Scrap_Code; "Scrap Code") { }
            column(Work_Center_Group_Code; "Work Center Group Code") { }
            column(Work_Shift_Code; "Work Shift Code") { }
            column(Direct_Cost; "Direct Cost") { }
            column(Overhead_Cost; "Overhead Cost") { }
            column(Direct_Cost__ACY_; "Direct Cost (ACY)") { }
            column(Overhead_Cost__ACY_; "Overhead Cost (ACY)") { }
            column(Shortcut_Dimension_3_Code; "Shortcut Dimension 3 Code") { }
            column(Shortcut_Dimension_4_Code; "Shortcut Dimension 4 Code") { }
            column(Shortcut_Dimension_5_Code; "Shortcut Dimension 5 Code") { }
            column(Shortcut_Dimension_6_Code; "Shortcut Dimension 6 Code") { }
            column(Shortcut_Dimension_7_Code; "Shortcut Dimension 7 Code") { }
            column(Shortcut_Dimension_8_Code; "Shortcut Dimension 8 Code") { }
            column(GetEmplName; GetEmplName("Shortcut Dimension 6 Code")) { }
            column(GetShValueRoutig; GetShValueRoutig("Routing No.", "Routing No.", "Operation No.")) { }
            column("StandardHour"; "Output Quantity" * GetShValueRoutig("Routing No.", "Routing No.", "Operation No.")) { }
            column(CalcPerf; CalcPerf("Run Time", "Output Quantity" * GetShValueRoutig("Routing No.", "Routing No.", "Operation No."))) { }
            column(RqpStartDate; StartDate) { }
            column(RqpEndDate; EndDate) { }
            column(RqpLocation; Location) { }

            trigger OnAfterGetRecord()
            begin
                if StartDate = 0D then begin
                    StartDate := Today();
                end;
                if EndDate = 0D then begin
                    EndDate := Today()
                end;
                "Capacity Ledger Entry".SetRange("Posting Date", StartDate, EndDate);
                if Location <> '' then begin
                    "Capacity Ledger Entry".SetRange("Global Dimension 1 Code", Location);
                end;
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
                group("Period Setup")
                {
                    field("Starting Date"; StartDate)
                    {
                        ApplicationArea = All;

                    }

                    field("Finishing date"; EndDate)
                    {
                        ApplicationArea = All;
                    }
                    field("Location"; Location)
                    {
                        ApplicationArea = All;
                        Caption = 'Location (FFC / MDH)', Locked = true;

                    }
                }

            }
        }
    }
    labels
    {
        LblReportTitle = 'Capacity Ledger Entry', Locked = true;
        LblWorkCenterName = 'Work Center', Locked = true;
        LblPostingDate = 'Posting date', Locked = true;
        LblWoNum = 'Work Order', Locked = true;
        LblWorkCenterDesc = 'Work center desc.', Locked = true;
        LblWorkCenterNo = 'Work center no.', Locked = true;
        LblRunTime = 'Run time', Locked = true;
        LblOutputQty = 'Output qty', Locked = true;
        LblScrapQty = 'Scrap qty', Locked = true;
        LblItem = 'Item no.', Locked = true;
        LblShiftCode = 'Shift', Locked = true;
        LblDirectCost = 'Direct cost', Locked = true;
        LblToolNo = 'Tool', Locked = true;
        LblOperatorName = 'Operator', Locked = true;
        LblNormTime = 'Norm time', Locked = true;
        LblStdHour = 'Std. hour', Locked = true;
        LblActualHour = 'Act. hour', Locked = true;
        LblPerformance = 'Perf.', Locked = true;
        LblPage = 'Page :', Locked = true;
        LblLocation = 'Location', Locked = true;
        LblStartTime = 'Start time', Locked = true;
        LblFinishTime = 'Finish time', Locked = true;
        LblDuration = 'Op. time', Locked = true;

    }
    var
        myInt: Integer;
        StartDate: Date;
        EndDate: Date;
        Location: Code[20];
        Alkalmazott: Record Employee;
        RoutingHeader: Record "Routing Header";
        RoutingLine: Record "Routing Line";
        CapLedger: Record "Capacity Ledger Entry";


    local procedure CalcPerf(RunTime: Decimal; StdTime: Decimal): Decimal
    begin
        if RunTime = 0 then begin
            exit(0);
        end else begin
            exit(StdTime / RunTime);
        end;
    end;

    local procedure GetEmplName(Number: Code[20]): Text
    begin
        if Alkalmazott.Get(Number) then begin
            exit(Alkalmazott."First Name" + ' ' + Alkalmazott."Last Name");
        end
        else
            exit('');

    end;

    local procedure GetShValueRoutig(No: Code[20]; RoutingNoLine: Code[20]; OperationNo: Code[10]): Decimal
    begin
        if RoutingHeader.Get(No) then begin
            if No = '07-2000-0002' then begin
                exit(0);
            end;
            if RoutingHeader.Status = RoutingHeader.Status::Certified then begin
                if RoutingLine.Get(RoutingNoLine, '', OperationNo) then begin
                    exit(RoutingLine."Run Time");
                end else begin
                    exit(0);
                end;
            end;
        end else
            exit(0);
    end;

    local procedure GetStartTime(Entry: Integer): Text
    begin
        CapLedger.Init();
        if CapLedger.Get(Entry) then
            exit(FORMAT(CapLedger."Starting Time", 0, '<Hours24,2>:<Minutes,2>'));
    end;


    local procedure GetFinishTime(Entry: Integer): Text
    begin
        CapLedger.Init();
        if CapLedger.Get(Entry) then
            exit(FORMAT(CapLedger."Ending Time", 0, '<Hours24,2>:<Minutes,2>'));
    end;

    local procedure CalcDuraation(OpStartDate: Time; OpEndDate: Time): Decimal
    var
        return: Decimal;
    begin
        //                              Kerekitendő                  Pont. Irány
        return := ROUND((((OpEndDate - OpStartDate) / 1000) / 3600), 0.01, '>'); //a különbség ms-ben jön vissza.
        exit(return);
    end;

    trigger OnInitReport()
    begin
        Location := 'FFC';
    end;
}