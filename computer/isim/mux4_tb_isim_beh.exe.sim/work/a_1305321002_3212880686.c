/**********************************************************************/
/*   ____  ____                                                       */
/*  /   /\/   /                                                       */
/* /___/  \  /                                                        */
/* \   \   \/                                                       */
/*  \   \        Copyright (c) 2003-2009 Xilinx, Inc.                */
/*  /   /          All Right Reserved.                                 */
/* /---/   /\                                                         */
/* \   \  /  \                                                      */
/*  \___\/\___\                                                    */
/***********************************************************************/

/* This file is designed for use with ISim build 0xfbc00daa */

#define XSI_HIDE_SYMBOL_SPEC true
#include "xsi.h"
#include <memory.h>
#ifdef __GNUC__
#include <stdlib.h>
#else
#include <malloc.h>
#define alloca _alloca
#endif
static const char *ng0 = "/home/rashed/computer/mux4_tb.vhd";



static void work_a_1305321002_3212880686_p_0(char *t0)
{
    char *t1;
    char *t2;
    char *t3;
    char *t4;
    char *t5;
    char *t6;
    char *t7;
    char *t8;
    int64 t9;
    unsigned char t10;
    unsigned char t11;
    unsigned char t12;

LAB0:    t1 = (t0 + 2984U);
    t2 = *((char **)t1);
    if (t2 == 0)
        goto LAB2;

LAB3:    goto *t2;

LAB2:    xsi_set_current_line(29, ng0);
    t2 = (t0 + 3368);
    t3 = (t2 + 56U);
    t4 = *((char **)t3);
    t5 = (t4 + 56U);
    t6 = *((char **)t5);
    *((unsigned char *)t6) = (unsigned char)2;
    xsi_driver_first_trans_fast(t2);
    xsi_set_current_line(29, ng0);
    t2 = (t0 + 3432);
    t3 = (t2 + 56U);
    t4 = *((char **)t3);
    t5 = (t4 + 56U);
    t6 = *((char **)t5);
    *((unsigned char *)t6) = (unsigned char)3;
    xsi_driver_first_trans_fast(t2);
    xsi_set_current_line(29, ng0);
    t2 = (t0 + 3496);
    t3 = (t2 + 56U);
    t4 = *((char **)t3);
    t5 = (t4 + 56U);
    t6 = *((char **)t5);
    *((unsigned char *)t6) = (unsigned char)2;
    xsi_driver_first_trans_fast(t2);
    xsi_set_current_line(29, ng0);
    t2 = (t0 + 3560);
    t3 = (t2 + 56U);
    t4 = *((char **)t3);
    t5 = (t4 + 56U);
    t6 = *((char **)t5);
    *((unsigned char *)t6) = (unsigned char)3;
    xsi_driver_first_trans_fast(t2);
    xsi_set_current_line(31, ng0);
    t2 = (t0 + 5399);
    t4 = (t0 + 3624);
    t5 = (t4 + 56U);
    t6 = *((char **)t5);
    t7 = (t6 + 56U);
    t8 = *((char **)t7);
    memcpy(t8, t2, 2U);
    xsi_driver_first_trans_fast(t4);
    xsi_set_current_line(31, ng0);
    t9 = (20 * 1000LL);
    t2 = (t0 + 2792);
    xsi_process_wait(t2, t9);

LAB6:    *((char **)t1) = &&LAB7;

LAB1:    return;
LAB4:    xsi_set_current_line(32, ng0);
    t2 = (t0 + 1672U);
    t3 = *((char **)t2);
    t10 = *((unsigned char *)t3);
    t2 = (t0 + 1032U);
    t4 = *((char **)t2);
    t11 = *((unsigned char *)t4);
    t12 = (t10 == t11);
    if (t12 == 0)
        goto LAB8;

LAB9:    xsi_set_current_line(34, ng0);
    t2 = (t0 + 5431);
    t4 = (t0 + 3624);
    t5 = (t4 + 56U);
    t6 = *((char **)t5);
    t7 = (t6 + 56U);
    t8 = *((char **)t7);
    memcpy(t8, t2, 2U);
    xsi_driver_first_trans_fast(t4);
    xsi_set_current_line(34, ng0);
    t9 = (20 * 1000LL);
    t2 = (t0 + 2792);
    xsi_process_wait(t2, t9);

LAB12:    *((char **)t1) = &&LAB13;
    goto LAB1;

LAB5:    goto LAB4;

LAB7:    goto LAB5;

LAB8:    t2 = (t0 + 5401);
    xsi_report(t2, 30U, (unsigned char)2);
    goto LAB9;

LAB10:    xsi_set_current_line(35, ng0);
    t2 = (t0 + 1672U);
    t3 = *((char **)t2);
    t10 = *((unsigned char *)t3);
    t2 = (t0 + 1192U);
    t4 = *((char **)t2);
    t11 = *((unsigned char *)t4);
    t12 = (t10 == t11);
    if (t12 == 0)
        goto LAB14;

LAB15:    xsi_set_current_line(37, ng0);
    t2 = (t0 + 5463);
    t4 = (t0 + 3624);
    t5 = (t4 + 56U);
    t6 = *((char **)t5);
    t7 = (t6 + 56U);
    t8 = *((char **)t7);
    memcpy(t8, t2, 2U);
    xsi_driver_first_trans_fast(t4);
    xsi_set_current_line(37, ng0);
    t9 = (20 * 1000LL);
    t2 = (t0 + 2792);
    xsi_process_wait(t2, t9);

LAB18:    *((char **)t1) = &&LAB19;
    goto LAB1;

LAB11:    goto LAB10;

LAB13:    goto LAB11;

LAB14:    t2 = (t0 + 5433);
    xsi_report(t2, 30U, (unsigned char)2);
    goto LAB15;

LAB16:    xsi_set_current_line(38, ng0);
    t2 = (t0 + 1672U);
    t3 = *((char **)t2);
    t10 = *((unsigned char *)t3);
    t2 = (t0 + 1352U);
    t4 = *((char **)t2);
    t11 = *((unsigned char *)t4);
    t12 = (t10 == t11);
    if (t12 == 0)
        goto LAB20;

LAB21:    xsi_set_current_line(40, ng0);
    t2 = (t0 + 5495);
    t4 = (t0 + 3624);
    t5 = (t4 + 56U);
    t6 = *((char **)t5);
    t7 = (t6 + 56U);
    t8 = *((char **)t7);
    memcpy(t8, t2, 2U);
    xsi_driver_first_trans_fast(t4);
    xsi_set_current_line(40, ng0);
    t9 = (20 * 1000LL);
    t2 = (t0 + 2792);
    xsi_process_wait(t2, t9);

LAB24:    *((char **)t1) = &&LAB25;
    goto LAB1;

LAB17:    goto LAB16;

LAB19:    goto LAB17;

LAB20:    t2 = (t0 + 5465);
    xsi_report(t2, 30U, (unsigned char)2);
    goto LAB21;

LAB22:    xsi_set_current_line(41, ng0);
    t2 = (t0 + 1672U);
    t3 = *((char **)t2);
    t10 = *((unsigned char *)t3);
    t2 = (t0 + 1512U);
    t4 = *((char **)t2);
    t11 = *((unsigned char *)t4);
    t12 = (t10 == t11);
    if (t12 == 0)
        goto LAB26;

LAB27:    xsi_set_current_line(44, ng0);
    t2 = (t0 + 3368);
    t3 = (t2 + 56U);
    t4 = *((char **)t3);
    t5 = (t4 + 56U);
    t6 = *((char **)t5);
    *((unsigned char *)t6) = (unsigned char)3;
    xsi_driver_first_trans_fast(t2);
    xsi_set_current_line(44, ng0);
    t2 = (t0 + 3432);
    t3 = (t2 + 56U);
    t4 = *((char **)t3);
    t5 = (t4 + 56U);
    t6 = *((char **)t5);
    *((unsigned char *)t6) = (unsigned char)2;
    xsi_driver_first_trans_fast(t2);
    xsi_set_current_line(44, ng0);
    t2 = (t0 + 3496);
    t3 = (t2 + 56U);
    t4 = *((char **)t3);
    t5 = (t4 + 56U);
    t6 = *((char **)t5);
    *((unsigned char *)t6) = (unsigned char)3;
    xsi_driver_first_trans_fast(t2);
    xsi_set_current_line(44, ng0);
    t2 = (t0 + 3560);
    t3 = (t2 + 56U);
    t4 = *((char **)t3);
    t5 = (t4 + 56U);
    t6 = *((char **)t5);
    *((unsigned char *)t6) = (unsigned char)2;
    xsi_driver_first_trans_fast(t2);
    xsi_set_current_line(46, ng0);
    t2 = (t0 + 5527);
    t4 = (t0 + 3624);
    t5 = (t4 + 56U);
    t6 = *((char **)t5);
    t7 = (t6 + 56U);
    t8 = *((char **)t7);
    memcpy(t8, t2, 2U);
    xsi_driver_first_trans_fast(t4);
    xsi_set_current_line(46, ng0);
    t9 = (20 * 1000LL);
    t2 = (t0 + 2792);
    xsi_process_wait(t2, t9);

LAB30:    *((char **)t1) = &&LAB31;
    goto LAB1;

LAB23:    goto LAB22;

LAB25:    goto LAB23;

LAB26:    t2 = (t0 + 5497);
    xsi_report(t2, 30U, (unsigned char)2);
    goto LAB27;

LAB28:    xsi_set_current_line(47, ng0);
    t2 = (t0 + 1672U);
    t3 = *((char **)t2);
    t10 = *((unsigned char *)t3);
    t2 = (t0 + 1032U);
    t4 = *((char **)t2);
    t11 = *((unsigned char *)t4);
    t12 = (t10 == t11);
    if (t12 == 0)
        goto LAB32;

LAB33:    xsi_set_current_line(49, ng0);
    t2 = (t0 + 5569);
    t4 = (t0 + 3624);
    t5 = (t4 + 56U);
    t6 = *((char **)t5);
    t7 = (t6 + 56U);
    t8 = *((char **)t7);
    memcpy(t8, t2, 2U);
    xsi_driver_first_trans_fast(t4);
    xsi_set_current_line(49, ng0);
    t9 = (20 * 1000LL);
    t2 = (t0 + 2792);
    xsi_process_wait(t2, t9);

LAB36:    *((char **)t1) = &&LAB37;
    goto LAB1;

LAB29:    goto LAB28;

LAB31:    goto LAB29;

LAB32:    t2 = (t0 + 5529);
    xsi_report(t2, 40U, (unsigned char)2);
    goto LAB33;

LAB34:    xsi_set_current_line(50, ng0);
    t2 = (t0 + 1672U);
    t3 = *((char **)t2);
    t10 = *((unsigned char *)t3);
    t2 = (t0 + 1192U);
    t4 = *((char **)t2);
    t11 = *((unsigned char *)t4);
    t12 = (t10 == t11);
    if (t12 == 0)
        goto LAB38;

LAB39:    xsi_set_current_line(52, ng0);
    t2 = (t0 + 5611);
    t4 = (t0 + 3624);
    t5 = (t4 + 56U);
    t6 = *((char **)t5);
    t7 = (t6 + 56U);
    t8 = *((char **)t7);
    memcpy(t8, t2, 2U);
    xsi_driver_first_trans_fast(t4);
    xsi_set_current_line(52, ng0);
    t9 = (20 * 1000LL);
    t2 = (t0 + 2792);
    xsi_process_wait(t2, t9);

LAB42:    *((char **)t1) = &&LAB43;
    goto LAB1;

LAB35:    goto LAB34;

LAB37:    goto LAB35;

LAB38:    t2 = (t0 + 5571);
    xsi_report(t2, 40U, (unsigned char)2);
    goto LAB39;

LAB40:    xsi_set_current_line(53, ng0);
    t2 = (t0 + 1672U);
    t3 = *((char **)t2);
    t10 = *((unsigned char *)t3);
    t2 = (t0 + 1352U);
    t4 = *((char **)t2);
    t11 = *((unsigned char *)t4);
    t12 = (t10 == t11);
    if (t12 == 0)
        goto LAB44;

LAB45:    xsi_set_current_line(55, ng0);
    t2 = (t0 + 5653);
    t4 = (t0 + 3624);
    t5 = (t4 + 56U);
    t6 = *((char **)t5);
    t7 = (t6 + 56U);
    t8 = *((char **)t7);
    memcpy(t8, t2, 2U);
    xsi_driver_first_trans_fast(t4);
    xsi_set_current_line(55, ng0);
    t9 = (20 * 1000LL);
    t2 = (t0 + 2792);
    xsi_process_wait(t2, t9);

LAB48:    *((char **)t1) = &&LAB49;
    goto LAB1;

LAB41:    goto LAB40;

LAB43:    goto LAB41;

LAB44:    t2 = (t0 + 5613);
    xsi_report(t2, 40U, (unsigned char)2);
    goto LAB45;

LAB46:    xsi_set_current_line(56, ng0);
    t2 = (t0 + 1672U);
    t3 = *((char **)t2);
    t10 = *((unsigned char *)t3);
    t2 = (t0 + 1512U);
    t4 = *((char **)t2);
    t11 = *((unsigned char *)t4);
    t12 = (t10 == t11);
    if (t12 == 0)
        goto LAB50;

LAB51:    xsi_set_current_line(58, ng0);
    t2 = (t0 + 5695);
    xsi_report(t2, 30U, (unsigned char)0);
    xsi_set_current_line(59, ng0);

LAB54:    *((char **)t1) = &&LAB55;
    goto LAB1;

LAB47:    goto LAB46;

LAB49:    goto LAB47;

LAB50:    t2 = (t0 + 5655);
    xsi_report(t2, 40U, (unsigned char)2);
    goto LAB51;

LAB52:    goto LAB2;

LAB53:    goto LAB52;

LAB55:    goto LAB53;

}


extern void work_a_1305321002_3212880686_init()
{
	static char *pe[] = {(void *)work_a_1305321002_3212880686_p_0};
	xsi_register_didat("work_a_1305321002_3212880686", "isim/mux4_tb_isim_beh.exe.sim/work/a_1305321002_3212880686.didat");
	xsi_register_executes(pe);
}
