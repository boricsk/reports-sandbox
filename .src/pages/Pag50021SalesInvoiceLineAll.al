page 50021 "SEI Sales Invoice Line All"
{
    Caption = 'SEI Sales Invoice Line All';
    PageType = List;
    SourceTable = "Sales Invoice Line";
    //SourceTableView = where("Document Type" = const(Order));

    Editable = false;
    UsageCategory = Lists;

    layout
    {
        area(content)
        {
            repeater(General)
            {
                field("Bill-to Customer No."; Rec."Bill-to Customer No.")
                {
                    ApplicationArea = All;
                }
                field("No."; Rec."No.") { ApplicationArea = All; }
                field("Document No."; Rec."Document No.") { ApplicationArea = All; }
                field("Customer Name"; GetCustomerName(Rec."Document No.")) { ApplicationArea = All; }
                field("SAP SO Num."; GetSapSo(Rec."Document No.")) { ApplicationArea = All; }
                field("SAP PO Num."; GetSapPo(Rec."Document No.")) { ApplicationArea = All; }
                field("SEI SAP Order Unique ID"; Rec."SEI SAP Order Unique ID")
                {
                    ApplicationArea = All;
                }
                field("SEI Changed Order Date"; Rec."SEI Changed Order Date")
                {
                    ApplicationArea = All;
                }
                field("SEI SAP Original Req. Date"; Rec."SEI SAP Original Req. Date")
                {
                    ApplicationArea = All;
                }
                field("Posting Date"; Rec."Posting Date")
                {
                    ApplicationArea = All;
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = All;
                }
                field("Shortcut Dimension 1 Code"; Rec."Shortcut Dimension 1 Code")
                {
                    ApplicationArea = All;
                }
                field("Item Reference Unit of Measure"; Rec."Item Reference Unit of Measure")
                {
                    ApplicationArea = All;
                }
                field("Unit Cost"; Rec."Unit Cost")
                {
                    ApplicationArea = All;
                }
                field("Unit Cost (LCY)"; Rec."Unit Cost (LCY)")
                {
                    ApplicationArea = All;
                }
                field("Unit Price"; Rec."Unit Price")
                {
                    ApplicationArea = All;
                }
                field(Quantity; Rec.Quantity)
                {
                    ApplicationArea = All;
                }
                field("Line Amount"; Rec."Line Amount")
                {
                    ApplicationArea = All;
                }
                field("Currency Code"; GetInvCurrencyCode(Rec."Document No."))
                {
                    ApplicationArea = All;
                }

            }
        }

    }
    actions
    {
        area(navigation)
        {
            group("&Line")
            {
                Caption = '&Line';
                Image = Line;
                action(Card)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Show Document';
                    Image = View;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    ShortCutKey = 'F2';
                    ToolTip = 'Open the document that the selected line exists on.';

                    trigger OnAction()
                    var
                        PageManagement: Codeunit "Page Management";
                    begin
                        InvoiceHeader.Init();
                        if InvoiceHeader.Get(Rec."Document No.") then begin
                            PageManagement.PageRun(InvoiceHeader);
                        end;
                    end;
                }
            }
        }
    }
    var
        InvoiceHeader: Record "Sales Invoice Header";

    local procedure GetCustomerName(OrderNum: Code[20]): Text;
    var
        SalesInvHeader: Record "Sales Invoice Header";
    begin
        SalesInvHeader.Init();
        SalesInvHeader.Get(OrderNum);
        //SalesHeader.SetFilter("No.", OrderNum);
        exit(SalesInvHeader."Ship-to Name");
    end;

    local procedure GetSapSo(OrderNum: Code[20]): Text;
    var
        SalesInvHeader: Record "Sales Invoice Header";
    begin
        SalesInvHeader.Init();
        SalesInvHeader.Get(OrderNum);
        exit(SalesInvHeader."SEI SAP SO No.");
    end;

    local procedure GetSapPo(OrderNum: Code[20]): Text;
    var
        SalesInvHeader: Record "Sales Invoice Header";
    begin
        SalesInvHeader.Init();
        SalesInvHeader.Get(OrderNum);
        exit(SalesInvHeader."SEI SAP PO No.");
    end;

    local procedure GetInvCurrencyCode(OrderNum: Code[20]): Text;
    var
        SalesInvHeader: Record "Sales Invoice Header";
    begin
        SalesInvHeader.Init();
        SalesInvHeader.Get(OrderNum);
        exit(SalesInvHeader."Currency Code");
    end;

}
