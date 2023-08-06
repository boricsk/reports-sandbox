pageextension 50095 "Pag-Ext50097.SEIFirmPlannedWO" extends "Firm Planned Prod. Order"
{
    actions
    {
        addlast("F&unctions")
        {
            action("Print document")
            {
                ApplicationArea = All;
                Image = Print;
                trigger OnAction()
                var
                    Prod_Order: Record "Production Order";
                begin
                    Prod_Order.Reset();
                    Prod_Order.SetRange(Prod_Order."No.", rec."No.");
                    if (strpos(rec."Source No.", 'ASSY') <> 0) or (StrPos(rec."Source No.", '07-') <> 0) or (StrPos(rec."Source No.", '0M-V810') <> 0) or (StrPos(rec."Source No.", '04-') <> 0) then begin
                        Report.RunModal(Report::"SEI Production Order Finished", true, false, Prod_Order);
                    end else begin
                        if (rec."Location Code" = 'FFC STOCK') and (StrPos(rec."Source No.", '0L-') <> 0) then begin
                            Report.RunModal(Report::"SEI Production Order 0L", true, false, Prod_Order);
                        end;
                        if (rec."Location Code" = 'FFC STOCK') and (StrPos(rec."Source No.", '0P-') <> 0) then begin
                            Report.RunModal(Report::"SEI Production Order 0P", true, false, Prod_Order);
                        end;
                        if (rec."Location Code" = 'FFC STOCK') and (StrPos(rec."Source No.", '0F-') <> 0) then begin
                            Report.RunModal(Report::"SEI Production Order 0F", true, false, Prod_Order);
                        end;
                    end;
                end;
            }
        }
    }
}
