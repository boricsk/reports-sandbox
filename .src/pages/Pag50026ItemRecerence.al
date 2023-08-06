page 50026 "SEI Item reference"
{
    Caption = 'SEI Item reference';
    PageType = List;
    SourceTable = "Item Reference";
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

                field("Item No."; Rec."Item No.") { ApplicationArea = All; }
                field("Variant Code"; Rec."Variant Code") { ApplicationArea = All; }
                field("Unit of Measure"; Rec."Unit of Measure") { ApplicationArea = All; }
                field("Reference Type"; Rec."Reference Type") { ApplicationArea = All; }
                field("Reference Type No."; Rec."Reference Type No.") { ApplicationArea = All; }
                field("Customer Name"; GetCustomerName(Rec."Reference Type No.")) { ApplicationArea = All; }
                field("Reference No."; Rec."Reference No.") { ApplicationArea = All; }
                field(Description; Rec.Description) { ApplicationArea = All; }
                field("Description 2"; Rec."Description 2") { ApplicationArea = All; }
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

    local procedure GetCustomerName(Number: Code[20]): Text
    var
        Customer_Rec: Record Customer;
    begin
        Customer_Rec.Init();
        if Customer_Rec.get(Number) then begin
            exit(Customer_Rec.Name)
        end;
    end;

}