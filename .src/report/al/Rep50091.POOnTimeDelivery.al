report 50091 "SEI PO On Time Delivery"
{
    DefaultLayout = RDLC;
    RDLCLayout = '.src/report/rdlc/Rep50091.POOnTimeDelivery.rdlc';
    ApplicationArea = All;
    Caption = 'SEI On Time Delivery';
    UsageCategory = ReportsAndAnalysis;

    dataset
    {
        dataitem("SEI POC Master data"; "SEI POC Master data")
        {
            column(PO_Number; "PO Number") { }
            column(Item_number; "Item number") { }
            column(Item_description; "Item description") { }
            column("Area"; "Area") { }
            column(Shipping_unit; "Shipping unit") { }
            column(Completely_arrived; "Completely arrived") { }
            column(Completely_arrive_date; "Completely arrive date") { }
            column(Requesterd_ETA; "Requesterd ETA") { }
            column(Requested_LT; "Requested LT") { }
            column(Last_shipment_LT; "Last shipment LT") { }
            column(Supplier; Supplier) { }
            column(Supplier_name; "Supplier name") { }
            column(Delay_in_days; "Delay in days") { }
            column(calcDelayedShipment; calcDelayedShipment("Delay in days")) { }
            column(calcOnTimeShipment; calcOnTimeShipment("Delay in days")) { }
            column(businessYear; businessYear) { }
            column(Quantity; Quantity) { }
            column(On_time_quantity; "On time quantity") { }
            column(Delayed_quantity; "Delayed quantity") { }
            column(Month; Month) { }
            column(Coil_LT; "Coil LT") { }
            column(Cut_LT; "Cut LT") { }
            column(Finish_LT; "Finish LT") { }
            column(Spec_LT; "Spec LT") { }
            column(getTargetLTCoil; getTargetLTCoil()) { }
            column(getTargetLTCut; getTargetLTCut()) { }
            column(getTargetLTFinish; getTargetLTFinish()) { }
            column(getTargetLTSpec; getTargetLTSpec()) { }


            trigger OnPreDataItem()
            begin
                "SEI POC Master data".SetRange("Business year", businessYear);
                "SEI POC Master data".SetFilter("Completely arrived", 'true');
            end;
        }

    }

    requestpage
    {
        SaveValues = true;
        Caption = 'Purchasing on time delivery report';
        layout
        {
            area(Content)
            {
                group("Enter business year")
                {
                    field(businessYear; businessYear)
                    {
                        Caption = 'Enter business year';
                        ApplicationArea = All;

                    }
                }
            }
        }

    }

    labels
    {
        LblTitle = 'Purchase On Time Delivery Report', Locked = true;
        LblTTLOrderdQty = 'TTL ordered qty.';
        LblDelayQty = 'Delayed qty.';
        lblOnTimeQty = 'On time qty.';
        lblPerformedAVGLTCoil = 'Performed AVG LT (Coil)';
        lblPerformedAVGLTCut = 'Performed AVG LT (Cut)';
        lblPerformedAVGLTFinish = 'Performed AVG LT (Finish)';
        lblPerformedAVGLTSpec = 'Performed AVG LT (Spec mat.)';
        LblTargetLT = 'Target LT';
        LblOTDRatio = 'OTD ratio';
        lblBY = 'Business year : ';

    }

    trigger OnInitReport()
    begin

    end;

    var
        businessYear: Integer;
        manufacturingSetup: Record "Manufacturing Setup";

    local procedure calcDelayedShipment(DelayInDay: Integer): Integer
    begin
        if DelayInDay <> 0 then
            exit(1)
        else
            exit(0);
    end;

    local procedure calcOnTimeShipment(DelayInDay: Integer): Integer
    begin
        if DelayInDay = 0 then
            exit(1)
        else
            exit(0);
    end;

    local procedure getTargetLTCoil(): Integer
    begin
        manufacturingSetup.Init();
        manufacturingSetup.Get();
        exit(manufacturingSetup."Coil target LT");
    end;

    local procedure getTargetLTCut(): Integer
    begin
        manufacturingSetup.Init();
        manufacturingSetup.Get();
        exit(manufacturingSetup."Cut target LT");
    end;

    local procedure getTargetLTFinish(): Integer
    begin
        manufacturingSetup.Init();
        manufacturingSetup.Get();
        exit(manufacturingSetup."Finished target LT");
    end;

    local procedure getTargetLTSpec(): Integer
    begin
        manufacturingSetup.Init();
        manufacturingSetup.Get();
        exit(manufacturingSetup."Spec-mat target LT");
    end;
}