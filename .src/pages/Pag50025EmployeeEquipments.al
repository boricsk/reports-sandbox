page 50025 "SEI Employee Equipments"
{
    Caption = 'SEI Employee Equipments';
    PageType = List;
    SourceTable = "Misc. Article Information";
    //SourceTableView = where(Status = const(Released));
    //CardPageId = 99000831;
    Editable = false;
    UsageCategory = Lists;
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            repeater(General)
            {
                field("Employee No."; Rec."Employee No.") { ApplicationArea = All; }
                field("Employee Name"; GetEmployeeName(Rec."Employee No.")) { ApplicationArea = All; }
                field("Misc. Article Code"; Rec."Misc. Article Code") { ApplicationArea = All; }
                field(Description; Rec.Description) { ApplicationArea = All; }
                field("From Date"; Rec."From Date") { ApplicationArea = All; }
                field("To Date"; Rec."To Date") { ApplicationArea = All; }
                field("In Use"; Rec."In Use") { ApplicationArea = All; }
                field("Serial No."; Rec."Serial No.") { ApplicationArea = All; }


            }
        }

    }
    actions
    {
        area(navigation)
        {


        }
    }
    var
        SEIEmployee: Record Employee;

    local procedure GetEmployeeName(Num: Code[20]): Text
    begin
        SEIEmployee.Init();
        if SEIEmployee.Get(Num) then begin
            exit(SEIEmployee."Search Name");
        end;
    end;
}