page 50019 "SEI Sales Order Line"
{
    Caption = 'SEI Sales Order Line';
    PageType = List;
    SourceTable = "Sales Line";
    //SourceTableView = sorting("Planned Delivery Date") order(descending) where("Document Type" = const(Order), "Outstanding Quantity" = filter(<> 0));
    SourceTableView = where("Document Type" = const(Order), "Outstanding Quantity" = filter(<> 0));

    //CardPageId = 42;

    Editable = false;
    UsageCategory = Lists;

    layout
    {
        area(content)
        {
            repeater(General)
            {
                field("Document No."; Rec."Document No.") { ApplicationArea = All; }
                field("Order Date"; GetOrderDate(Rec."Document No."))
                {
                    ApplicationArea = All;
                }
                field("Order status"; GetStatus(Rec."Document No."))
                {
                    ApplicationArea = All;
                    //Style = Strong;
                    StyleExpr = statusStyle;
                }
                field("Bill-to Customer No."; Rec."Bill-to Customer No.")
                {
                    ApplicationArea = All;
                }
                field("No."; Rec."No.") { ApplicationArea = All; Style = StrongAccent; }

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
                    //Style = Ambiguous;

                }
                field("Is SLT order?"; CheckSLT(Rec."SEI SAP Original Req. Date", Rec."Document No."))
                {
                    ApplicationArea = All;
                    StyleExpr = sltStyle;

                }
                field("SO Age [Week]"; getSoAge(GetOrderDate(Rec."Document No.")))
                {
                    ApplicationArea = All;
                }

                field("Changed LT [Week]"; getNewRequestLT(GetOrderDate(Rec."Document No."), rec."SEI Changed Order Date"))
                {
                    ApplicationArea = All;
                    StyleExpr = newRequestStyle;
                }
                field("Requested LT [Week]"; getNewRequestLT(GetOrderDate(Rec."Document No."), rec."SEI SAP Original Req. Date"))
                {
                    ApplicationArea = All;
                    //StyleExpr = newRequestStyle;
                }

                field("Confirmed LT [Week]"; getNewRequestLT(GetOrderDate(Rec."Document No."), rec."Planned Shipment Date"))
                {
                    ApplicationArea = All;
                    //StyleExpr = newRequestStyle;
                }

                field("Planned Delivery Date"; Rec."Planned Delivery Date")
                {
                    ApplicationArea = All;
                    StyleExpr = dateStyle;

                }
                field("Planned Shipment Date"; Rec."Planned Shipment Date")
                {
                    ApplicationArea = All;
                }
                field("SEI Confirmed ETA Date"; Rec."SEI Confirmed ETA Date")
                {
                    ApplicationArea = All;
                }
                field(isRequestChanged; isRequestChanged)
                {
                    ApplicationArea = All;
                    Caption = 'Request changed';
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
                field("Line Amount"; Rec."Line Amount")
                { ApplicationArea = All; }
                field(Quantity; Rec.Quantity)
                {
                    ApplicationArea = All;
                }
                field("Outstanding Quantity"; Rec."Outstanding Quantity")
                {
                    ApplicationArea = All;
                }
                field("Outstanding Amount (LCY)"; Rec."Outstanding Amount (LCY)")
                { ApplicationArea = All; }

                field("Outstanding Amount"; Rec."Outstanding Amount")
                { ApplicationArea = All; }
                field("Quantity Invoiced"; Rec."Quantity Invoiced")
                {
                    ApplicationArea = All;
                }
                field("Quantity Shipped"; Rec."Quantity Shipped")
                {
                    ApplicationArea = All;
                }
                field("Currency Code"; Rec."Currency Code")
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
                        SalesHeader.Init();
                        if SalesHeader.Get(Rec."Document Type", Rec."Document No.") then begin
                            PageManagement.PageRun(SalesHeader);
                        end;
                    end;
                }

            }


        }
    }
    trigger OnOpenPage()
    begin
        manufacturingSetup.Init();
        manufacturingSetup.Get();
        //rec.SetView('where ("Planned Sipment Date" = filter(<> rec."SEI Changed Order Date")');
    end;

    trigger OnAfterGetRecord()
    var
        salesHeader: Record "Sales Header";
    begin
        if CheckSLT(Rec."SEI SAP Original Req. Date", Rec."Document No.") = 'SLT' then begin
            sltStyle := 'Unfavorable';
        end else begin
            sltStyle := 'Favorable';
        end;

        if GetStatus(Rec."Document No.") = format(salesHeader.Status::Open) then begin
            statusStyle := 'Attention';
        end else begin
            statusStyle := 'None';
        end;

        if rec."SEI Changed Order Date" = 0D then begin
            dateStyle := 'Ambiguous';
            isRequestChanged := false;
        end else begin
            if CheckChangedDate(Rec."Planned Delivery Date", Rec."SEI Changed Order Date", Rec."Document No.") then begin
                dateStyle := 'Strong';
                isRequestChanged := true;
            end else begin

                dateStyle := '';
                isRequestChanged := false;

            end;
        end;

        if getNewRequestLT(GetOrderDate(Rec."Document No."), rec."SEI Changed Order Date") < manufacturingSetup."Standard lead time in weeks" then
            newRequestStyle := 'Attention'
        else
            newRequestStyle := 'None'


    end;

    var
        SalesHeader: Record "Sales Header";
        manufacturingSetup: Record "Manufacturing Setup";
        sltStyle, statusStyle, dateStyle, newRequestStyle : Text;
        isRequestChanged: Boolean;

    local procedure GetCustomerName(OrderNum: Code[20]): Text;
    var
        SalesHeader: Record "Sales Header";
    begin
        SalesHeader.Init();
        SalesHeader.Get(Rec."Document Type"::Order, OrderNum);
        //SalesHeader.SetFilter("No.", OrderNum);
        exit(SalesHeader."Ship-to Name");
    end;

    local procedure GetSapSo(OrderNum: Code[20]): Text;
    var
        SalesHeader: Record "Sales Header";
    begin
        SalesHeader.Init();
        SalesHeader.Get(Rec."Document Type"::Order, OrderNum);
        exit(SalesHeader."SEI SAP SO No.");
    end;

    local procedure getSoAge(Issue: Date): Decimal
    begin
        exit(Round((today() - Issue) / 7, 0.1, '='))
    end;

    local procedure getNewRequestLT(Issue: Date; newReq: Date): Decimal
    begin
        if newReq = 0D then
            exit(0)
        else
            exit(Round((newReq - Issue) / 7, 0.1, '='))
    end;

    local procedure GetSapPo(OrderNum: Code[20]): Text;
    var
        SalesHeader: Record "Sales Header";
    begin
        SalesHeader.Init();
        SalesHeader.Get(Rec."Document Type"::Order, OrderNum);
        exit(SalesHeader."SEI SAP PO No.");
    end;

    local procedure CheckSLT(OriginalRequestedDate: Date; OrderNum: Code[20]): Text
    var
        SalesHeader: Record "Sales Header";
        OrderDate: Date;
        SLTPeriod: Integer;
    begin
        SalesHeader.Init();
        OrderDate := 0D;
        SLTPeriod := manufacturingSetup."Standard lead time in weeks" * 7;
        if SalesHeader.Get(Rec."Document Type"::Order, OrderNum) then begin
            OrderDate := SalesHeader."Order Date";
        end;
        if ((OrderDate + SLTPeriod) > OriginalRequestedDate) then begin
            //sltStyle := 'Strong';
            exit('SLT');
        end else begin
            //sltStyle := 'Favorable';
            exit('Not SLT');
        end;
    end;

    local procedure CheckChangedDate(PlannedDeliveryDate: Date; ChangedDate: Date; OrderNum: Code[20]): Boolean
    var
    //SalesLine: Record "Sales Line";

    begin
        //SalesLine.Init();
        //if SalesLine.Get(Rec."Document Type"::Order, OrderNum) then begin
        if (PlannedDeliveryDate) = (ChangedDate) then begin
            //sltStyle := 'Strong';
            exit(false);
        end else begin
            //sltStyle := 'Favorable';
            exit(true);
        end;
        //nd;
    end;

    local procedure GetOrderDate(OrderNum: Code[20]): Date;
    var
        SalesHeader: Record "Sales Header";
    begin
        SalesHeader.Init();
        if SalesHeader.Get(Rec."Document Type"::Order, OrderNum) then begin
            exit(SalesHeader."Order Date");
        End;
    end;

    local procedure GetStatus(OrderNum: Code[20]): Text;
    var
        SalesHeader: Record "Sales Header";
    begin
        SalesHeader.Init();
        if SalesHeader.Get(Rec."Document Type"::Order, OrderNum) then begin
            exit(Format(SalesHeader.Status));
        End;
    end;
}
