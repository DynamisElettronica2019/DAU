

#ifndef DD_CAN_H
#define DD_CAN_H

/************************** EFI ***************************/
#define EFI_HALL_ID                     0b01100000100 //772
#define EFI_WATER_TEMPERATURE_ID        0b01100001100 //780
#define EFI_OIL_T_ENGINE_BAT_ID         0b01100001101 //781
#define EFI_GEAR_RPM_TPS_APPS_ID        0b01100000101 //773
#define EFI_TRACTION_CONTROL_ID         0b01100000110 //774
#define EFI_FUEL_FAN_H2O_LAUNCH_ID      0b01100001110 //782
#define EFI_PRESSURES_LAMBDA_SMOT_ID    0b01100000111 //775
#define EFI_DIAG_IGN_EXHAUST_ID         0b01100001111 //783


/************************** GCU ***************************/
#define GCU_TRACTION_CONTROL_EFI_ID     0b10100000000 //1280       MANDATO SOLO DA GCU AD EFI!!!!
#define GCU_LAUNCH_CONTROL_EFI_ID       0b10100000001 //1281       MANDATO SOLO DA GCU AD EFI!!!!
#define GCU_CLUTCH_FB_SW_ID             0b01100010000 //784
#define GCU_GEAR_TIMING_TELEMETRY_ID    0b11100001101 //1624


/********************* STEERING WHEEL *********************/
#define SW_FIRE_GCU_ID                  0b01000000100 //516
#define SW_GEARSHIFT_ID                 0b01000000000 //512
#define SW_CLUTCH_TARGET_GCU_ID         0b01000000001 //513
#define SW_LAUNCH_CONTROL_GCU_ID        0b01000000010 //514
#define SW_TRACTION_CONTROL_GCU_ID      0b01000000011 //515
#define SW_BRAKE_BIAS_EBB_ID            0b10000000000 //1024
#define SW_DRS_GCU_ID                   0b01000000101 //517


/************************** DCU ***************************/
#define DCU_GEAR_TIMING_GCU_ID          0b01000000110 //518
#define DCU_AUTO_GEARSHIFT_GCU_ID       0b01000000111 //519


/************************** DAU ***************************/
#define DAU_FR_ID                       0b11001010000 //1616
#define DAU_FL_ID                       0b11001010001 //1617
#define DAU_REAR_ID                     0b11001010010 //1618
#define DAU_FR_APPS_ID                  0b11001010011 //1619
#define IR_FL_ID                        0b11001010100 //1620
#define IR_FR_ID                        0b11001010101 //1621
#define IR_RL_ID                        0b11001010110 //1622
#define IR_RR_ID                        0b11001010111 //1623


/************************** IMU ***************************/
#define IMU_DATA_1_ID                   0b11100001010 //1802
#define IMU_DATA_2_ID                   0b11100001011 //1803
#define IMU_DATA_3_ID                   0b11100001100 //1804


/************************** EBB ***************************/
#define EBB_BIAS_ID                     0b11100001101 //1805


/************************* DEBUG **************************/
#define DAU_FR_DEBUG_ID                 0b01100010001 //785
#define DAU_FL_DEBUG_ID                 0b01100010010 //786
#define DAU_REAR_DEBUG_ID               0b01100010011 //787
#define SW_DEBUG_ID                     0b01100010100 //788
#define EBB_DEBUG_ID                    0b01100010101 //789
#define GCU_DEBUG_1_ID                  0b01100010110 //790
#define GCU_DEBUG_2_ID                  0b01100010111 //791
#define DCU_DEBUG_ID                    0b01100011000 //792


/************************** AUX ***************************/
#define SW_AUX_ID                       0b11111110000 //2032
#define GCU_AUX_ID                      0b11111110001 //2033
#define EBB_AUX_ID                      0b11111110010 //2034
#define DAU_FR_AUX_ID                   0b11111110011 //2035
#define DAU_FL_AUX_ID                   0b11111110100 //2036
#define DAU_REAR_AUX_ID                 0b11111110101 //2037
#define IMU_AUX_ID                      0b11111110110 //2038
#define DCU_AUX_ID                      0b11111110111 //2039


/******************* MASKS & FILTERS **********************/
//MASK
#define SW_MASK_EFI_DEBUG_IMU_EBB		0b11111100000 
//FILTERS
#define SW_FILTER_EFI_DEBUG				0b01100000000
#define SW_FILTER_IMU_EBB				0b11100000000

//MASK
#define GCU_MASK_EFI_SW_EBB				0b11111110100
//FILTERS
#define GCU_FILTER_EFI					0b01100000100
#define GCU_FILTER_SW_DCU				0b01000000000

//MASK
#define ALL_MASK_AUX					0b11111110000
//FILTER
#define ALL_FILTER_AUX					0b11111110000

//MASK
#define EBB_MASK_SW_DAUFR				0b11111111111
//FILTERS
#define EBB_FILTER_SW					0b10000000000
#define EBB_FILTER_DAUFR				0b11001010000


#endif //DD_CAN_H