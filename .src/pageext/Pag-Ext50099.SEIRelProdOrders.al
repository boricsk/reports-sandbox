pageextension 50099 SEIReleasedWOPageExt extends "Released Production Order"
{
    actions
    {
        addlast("F&unctions") // aminek a végéhez hozzátennénk
        {
            action("Consumption summary") // saját elnevezés, pl.: "PrintReport" (Ékezet ne legyen!!!)
            {
                ApplicationArea = All;
                Caption = 'Consumption summary'; // elnevezés, ez a fordító file-ba is bekerül
                Image = Report; // ikon megjelenése a menüben

                // teljesen új report adott record-ra
                trigger OnAction()
                var
                    ProductionOrder_50099: Record "Production Order";
                begin
                    // a record, amit átadunk (ez a legkülső dataitem a reportban)
                    ProductionOrder_50099.Reset();
                    ProductionOrder_50099.SetRange(ProductionOrder_50099."No.", Rec."No.");
                    //ProductionOrder_50099.SetRange("Journal Batch Name", Rec."Journal Batch Name");
                    // report futtatása
                    Report.RunModal(Report::"SEI Production order statistic", true, false, ProductionOrder_50099);
                end;
            }
            action("Print travel ticket")
            {
                ApplicationArea = All;
                Image = Report;
                trigger OnAction()
                var
                    Prod_Order: Record "Production Order";
                begin
                    Prod_Order.Reset();
                    Prod_Order.SetRange(Prod_Order."No.", rec."No.");
                    Report.RunModal(Report::"SEI Travel ticket", true, false, Prod_Order)
                end;
            }
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
                    if (strpos(rec."Source No.", 'ASSY') <> 0) or (StrPos(rec."Source No.", '07-') <> 0) or (StrPos(rec."Source No.", '0M-V810') <> 0) or (StrPos(rec."Source No.", '04-') <> 0) or (StrPos(rec."Source No.", '0M-MV11') <> 0) then begin
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