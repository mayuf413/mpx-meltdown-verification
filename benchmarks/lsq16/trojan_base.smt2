;(--------------Constants and arrays Declarations-------------
(declare-const T_RF (Array Int Int))
(declare-const T_DM (Array Int Int))
(declare-const T_IM (Array Int Int))

(declare-const T_Cache_Tag (Array (_ BitVec 2) Int))
(declare-const T_Cache_Data (Array (_ BitVec 2) Int))
(declare-const T_Cache_Valid (Array (_ BitVec 2) (_ BitVec 1)))

(declare-const T_PC (Int))

(declare-const T_IP (_ BitVec 6))	;64 entry ROB
(declare-const T_CP (_ BitVec 6))

(declare-const T_ROB_busy (Array (_ BitVec 6) (_ BitVec 1)))
(declare-const T_ROB_op (Array (_ BitVec 6) Int))
(declare-const T_ROB_destination (Array (_ BitVec 6) Int))
(declare-const T_ROB_result (Array (_ BitVec 6) Int))
(declare-const T_ROB_exception (Array (_ BitVec 6) (_ BitVec 1)))
(declare-const T_ROB_done (Array (_ BitVec 6) (_ BitVec 1)))
(declare-const T_ROB_Maddress (Array (_ BitVec 6) Int))

;------- RS 8 entries each ---------
(declare-const T_RS_op (Array (_ BitVec 3) Int))
(declare-const T_RS_ROB_dst (Array (_ BitVec 3) (_ BitVec 6)))
(declare-const T_RS_vj (Array (_ BitVec 3) Int))
(declare-const T_RS_vk (Array (_ BitVec 3) Int))
(declare-const T_RS_qj (Array (_ BitVec 3) (_ BitVec 6)))
(declare-const T_RS_qk (Array (_ BitVec 3) (_ BitVec 6)))
(declare-const T_RS_imm (Array (_ BitVec 3) Int))
(declare-const T_RS_dis (Array (_ BitVec 3) (_ BitVec 1)))
(declare-const T_RS_busy (Array (_ BitVec 3) (_ BitVec 1)))

;-------16 Entries LSQ------------------
; ------- 16 Entries LSQ ------------------
(declare-const T_LSQ_op    (Array (_ BitVec 4) Int))
(declare-const T_LSQ_ROB_dst (Array (_ BitVec 4) (_ BitVec 6)))
(declare-const T_LSQ_vj    (Array (_ BitVec 4) Int))
(declare-const T_LSQ_vk    (Array (_ BitVec 4) Int))
(declare-const T_LSQ_qj    (Array (_ BitVec 4) (_ BitVec 6)))
(declare-const T_LSQ_qk    (Array (_ BitVec 4) (_ BitVec 6)))
(declare-const T_LSQ_imm   (Array (_ BitVec 4) Int))
(declare-const T_LSQ_dis   (Array (_ BitVec 4) (_ BitVec 1)))
(declare-const T_LSQ_busy  (Array (_ BitVec 4) (_ BitVec 1)))


;-------Instruction Types ------------------
(declare-const Rtype (Int))
(declare-const Branch (Int))
(declare-const SLoad (Int))
(declare-const SStore (Int))
(declare-const Jump (Int))
(declare-const Load (Int))
(declare-fun LOAD_Unit (Int Int Int) Int)

(declare-const stall (_ BitVec 1))

;---Empty Values for Rollback reset
(declare-const empty_ROB_1bit (Array (_ BitVec 6) (_ BitVec 1)))
(declare-const empty_ROB_int (Array (_ BitVec 6) Int))

(declare-const empty_RS_int (Array (_ BitVec 3) Int))
(declare-const empty_RS_3bit (Array (_ BitVec 3) (_ BitVec 6)))
(declare-const empty_RS_1bit (Array (_ BitVec 3) (_ BitVec 1)))


(declare-const empty_LSQ_int (Array (_ BitVec 4) Int))
(declare-const empty_LSQ_3bit (Array (_ BitVec 4) (_ BitVec 6)))
(declare-const empty_LSQ_1bit (Array (_ BitVec 4) (_ BitVec 1)))

(declare-const Trojan (Int))
(declare-const Trigger (Int))

;)

;(--------------Functions--------------------------
;---Instruction Decoder-------
(declare-fun Inst_op (Int) Int)
(declare-fun Inst_rs (Int) Int)
(declare-fun Inst_rt (Int) Int)
(declare-fun Inst_rd (Int) Int)
(declare-fun Inst_imm (Int) Int)

(declare-fun pointer_ID (Int) Int)				;Uninterpreted funct to gen the Pointer ID on fetch/decode
(declare-fun pointer_TC (Int) (_ BitVec 1))	;Uninterpreted funct to gen the Pointer TC on fetch/decode
(declare-fun pointer_SC (Int) (_ BitVec 1))	;Uninterpreted funct to gen the Pointer SC on fetch/decode

(declare-fun Base (Int) Int)		;Uninterpreted function to fetch the Base address
(declare-fun Bound (Int) Int)		;Uninterpreted function to fetch the Bound address
(declare-fun Object_ID (Int) Int)	;Uninterpreted function to fetch the Object ID

;---Execution Units---------
(declare-fun ALU (Int Int Int Int) Int)
(declare-fun LSU (Int Int Int Int) Int)

;---Skip location 0 adder and subtractor----(ROB 0 Not used)----
(define-fun subtract ((input (_ BitVec 6)) ) (_ BitVec 6)
	(let
		(
			(sub_one (bvsub input (_ bv1 6)))
		)
	(let
		(
			(output 
				(ite (= sub_one #b000000) (_ bv63 6)
					sub_one
				)
			)
		)
	))
)
(define-fun addition ((input (_ BitVec 6)) ) (_ BitVec 6)
	(let
		(
			(add_one (bvadd input (_ bv1 6)))
		)
	(let
		(
			(output 
				(ite (= input #b111111) (_ bv1 6)
					add_one
				)
			)
		)
	))
)

;---RAT Manual Value Calculation functions----
(define-fun RAT ((IP (_ BitVec 6)) (register (Int)) (ROB_busy (Array (_ BitVec 6) (_ BitVec 1))) (ROB_op (Array (_ BitVec 6) Int)) (ROB_destination (Array (_ BitVec 6) Int)) ) (_ BitVec 6)
	(let((IP_m1 (subtract IP)))
	(let((IP_m2 (subtract IP_m1)))
	(let((IP_m3 (subtract IP_m2)))
	(let((IP_m4 (subtract IP_m3)))
	(let((IP_m5 (subtract IP_m4)))
	(let((IP_m6 (subtract IP_m5)))
	(let((IP_m7 (subtract IP_m6)))
	(let((IP_m8 (subtract IP_m7)))
	(let((IP_m9 (subtract IP_m8)))
	(let((IP_m10 (subtract IP_m9)))
	(let((IP_m11 (subtract IP_m10)))
	(let((IP_m12 (subtract IP_m11)))
	(let((IP_m13 (subtract IP_m12)))
	(let((IP_m14 (subtract IP_m13)))
	(let((IP_m15 (subtract IP_m14)))
	(let((IP_m16 (subtract IP_m15)))
	(let((IP_m17 (subtract IP_m16)))
	(let((IP_m18 (subtract IP_m17)))
	(let((IP_m19 (subtract IP_m18)))
	(let((IP_m20 (subtract IP_m19)))
	(let((IP_m21 (subtract IP_m20)))
	(let((IP_m22 (subtract IP_m21)))
	(let((IP_m23 (subtract IP_m22)))
	(let((IP_m24 (subtract IP_m23)))
	(let((IP_m25 (subtract IP_m24)))
	(let((IP_m26 (subtract IP_m25)))
	(let((IP_m27 (subtract IP_m26)))
	(let((IP_m28 (subtract IP_m27)))
	(let((IP_m29 (subtract IP_m28)))
	(let((IP_m30 (subtract IP_m29)))
	(let((IP_m31 (subtract IP_m30)))
	(let((IP_m32 (subtract IP_m31)))
	(let((IP_m33 (subtract IP_m32)))
	(let((IP_m34 (subtract IP_m33)))
	(let((IP_m35 (subtract IP_m34)))
	(let((IP_m36 (subtract IP_m35)))
	(let((IP_m37 (subtract IP_m36)))
	(let((IP_m38 (subtract IP_m37)))
	(let((IP_m39 (subtract IP_m38)))
	(let((IP_m40 (subtract IP_m39)))
	(let((IP_m41 (subtract IP_m40)))
	(let((IP_m42 (subtract IP_m41)))
	(let((IP_m43 (subtract IP_m42)))
	(let((IP_m44 (subtract IP_m43)))
	(let((IP_m45 (subtract IP_m44)))
	(let((IP_m46 (subtract IP_m45)))
	(let((IP_m47 (subtract IP_m46)))
	(let((IP_m48 (subtract IP_m47)))
	(let((IP_m49 (subtract IP_m48)))
	(let((IP_m50 (subtract IP_m49)))
	(let((IP_m51 (subtract IP_m50)))
	(let((IP_m52 (subtract IP_m51)))
	(let((IP_m53 (subtract IP_m52)))
	(let((IP_m54 (subtract IP_m53)))
	(let((IP_m55 (subtract IP_m54)))
	(let((IP_m56 (subtract IP_m55)))
	(let((IP_m57 (subtract IP_m56)))
	(let((IP_m58 (subtract IP_m57)))
	(let((IP_m59 (subtract IP_m58)))
	(let((IP_m60 (subtract IP_m59)))
	(let((IP_m61 (subtract IP_m60)))
	(let((IP_m62 (subtract IP_m61)))
	(let((IP_m63 (subtract IP_m62)))
	(let
		(	
			(RAT_output
				(ite (and (= #b1 (select ROB_busy IP_m1)) (or (= Rtype (select ROB_op IP_m1)) (= SLoad (select ROB_op IP_m1))) (= register (select ROB_destination IP_m1))) IP_m1
				(ite (and (= #b1 (select ROB_busy IP_m2)) (or (= Rtype (select ROB_op IP_m2)) (= SLoad (select ROB_op IP_m2))) (= register (select ROB_destination IP_m2))) IP_m2
				(ite (and (= #b1 (select ROB_busy IP_m3)) (or (= Rtype (select ROB_op IP_m3)) (= SLoad (select ROB_op IP_m3))) (= register (select ROB_destination IP_m3))) IP_m3
				(ite (and (= #b1 (select ROB_busy IP_m4)) (or (= Rtype (select ROB_op IP_m4)) (= SLoad (select ROB_op IP_m4))) (= register (select ROB_destination IP_m4))) IP_m4
				(ite (and (= #b1 (select ROB_busy IP_m5)) (or (= Rtype (select ROB_op IP_m5)) (= SLoad (select ROB_op IP_m5))) (= register (select ROB_destination IP_m5))) IP_m5
				(ite (and (= #b1 (select ROB_busy IP_m6)) (or (= Rtype (select ROB_op IP_m6)) (= SLoad (select ROB_op IP_m6))) (= register (select ROB_destination IP_m6))) IP_m6
				(ite (and (= #b1 (select ROB_busy IP_m7)) (or (= Rtype (select ROB_op IP_m7)) (= SLoad (select ROB_op IP_m7))) (= register (select ROB_destination IP_m7))) IP_m7
				(ite (and (= #b1 (select ROB_busy IP_m8)) (or (= Rtype (select ROB_op IP_m8)) (= SLoad (select ROB_op IP_m8))) (= register (select ROB_destination IP_m8))) IP_m8
				(ite (and (= #b1 (select ROB_busy IP_m9)) (or (= Rtype (select ROB_op IP_m9)) (= SLoad (select ROB_op IP_m9))) (= register (select ROB_destination IP_m9))) IP_m9
				(ite (and (= #b1 (select ROB_busy IP_m10)) (or (= Rtype (select ROB_op IP_m10)) (= SLoad (select ROB_op IP_m10))) (= register (select ROB_destination IP_m10))) IP_m10
				(ite (and (= #b1 (select ROB_busy IP_m11)) (or (= Rtype (select ROB_op IP_m11)) (= SLoad (select ROB_op IP_m11))) (= register (select ROB_destination IP_m11))) IP_m11
				(ite (and (= #b1 (select ROB_busy IP_m12)) (or (= Rtype (select ROB_op IP_m12)) (= SLoad (select ROB_op IP_m12))) (= register (select ROB_destination IP_m12))) IP_m12
				(ite (and (= #b1 (select ROB_busy IP_m13)) (or (= Rtype (select ROB_op IP_m13)) (= SLoad (select ROB_op IP_m13))) (= register (select ROB_destination IP_m13))) IP_m13
				(ite (and (= #b1 (select ROB_busy IP_m14)) (or (= Rtype (select ROB_op IP_m14)) (= SLoad (select ROB_op IP_m14))) (= register (select ROB_destination IP_m14))) IP_m14
				(ite (and (= #b1 (select ROB_busy IP_m15)) (or (= Rtype (select ROB_op IP_m15)) (= SLoad (select ROB_op IP_m15))) (= register (select ROB_destination IP_m15))) IP_m15
				(ite (and (= #b1 (select ROB_busy IP_m16)) (or (= Rtype (select ROB_op IP_m16)) (= SLoad (select ROB_op IP_m16))) (= register (select ROB_destination IP_m16))) IP_m16
				(ite (and (= #b1 (select ROB_busy IP_m17)) (or (= Rtype (select ROB_op IP_m17)) (= SLoad (select ROB_op IP_m17))) (= register (select ROB_destination IP_m17))) IP_m17
				(ite (and (= #b1 (select ROB_busy IP_m18)) (or (= Rtype (select ROB_op IP_m18)) (= SLoad (select ROB_op IP_m18))) (= register (select ROB_destination IP_m18))) IP_m18
				(ite (and (= #b1 (select ROB_busy IP_m19)) (or (= Rtype (select ROB_op IP_m19)) (= SLoad (select ROB_op IP_m19))) (= register (select ROB_destination IP_m19))) IP_m19
				(ite (and (= #b1 (select ROB_busy IP_m20)) (or (= Rtype (select ROB_op IP_m20)) (= SLoad (select ROB_op IP_m20))) (= register (select ROB_destination IP_m20))) IP_m20
				(ite (and (= #b1 (select ROB_busy IP_m21)) (or (= Rtype (select ROB_op IP_m21)) (= SLoad (select ROB_op IP_m21))) (= register (select ROB_destination IP_m21))) IP_m21
				(ite (and (= #b1 (select ROB_busy IP_m22)) (or (= Rtype (select ROB_op IP_m22)) (= SLoad (select ROB_op IP_m22))) (= register (select ROB_destination IP_m22))) IP_m22
				(ite (and (= #b1 (select ROB_busy IP_m23)) (or (= Rtype (select ROB_op IP_m23)) (= SLoad (select ROB_op IP_m23))) (= register (select ROB_destination IP_m23))) IP_m23
				(ite (and (= #b1 (select ROB_busy IP_m24)) (or (= Rtype (select ROB_op IP_m24)) (= SLoad (select ROB_op IP_m24))) (= register (select ROB_destination IP_m24))) IP_m24
				(ite (and (= #b1 (select ROB_busy IP_m25)) (or (= Rtype (select ROB_op IP_m25)) (= SLoad (select ROB_op IP_m25))) (= register (select ROB_destination IP_m25))) IP_m25
				(ite (and (= #b1 (select ROB_busy IP_m26)) (or (= Rtype (select ROB_op IP_m26)) (= SLoad (select ROB_op IP_m26))) (= register (select ROB_destination IP_m26))) IP_m26
				(ite (and (= #b1 (select ROB_busy IP_m27)) (or (= Rtype (select ROB_op IP_m27)) (= SLoad (select ROB_op IP_m27))) (= register (select ROB_destination IP_m27))) IP_m27
				(ite (and (= #b1 (select ROB_busy IP_m28)) (or (= Rtype (select ROB_op IP_m28)) (= SLoad (select ROB_op IP_m28))) (= register (select ROB_destination IP_m28))) IP_m28
				(ite (and (= #b1 (select ROB_busy IP_m29)) (or (= Rtype (select ROB_op IP_m29)) (= SLoad (select ROB_op IP_m29))) (= register (select ROB_destination IP_m29))) IP_m29
				(ite (and (= #b1 (select ROB_busy IP_m30)) (or (= Rtype (select ROB_op IP_m30)) (= SLoad (select ROB_op IP_m30))) (= register (select ROB_destination IP_m30))) IP_m30
                (ite (and (= #b1 (select ROB_busy IP_m31)) (or (= Rtype (select ROB_op IP_m31)) (= SLoad (select ROB_op IP_m31))) (= register (select ROB_destination IP_m31))) IP_m31
				(ite (and (= #b1 (select ROB_busy IP_m32)) (or (= Rtype (select ROB_op IP_m32)) (= SLoad (select ROB_op IP_m32))) (= register (select ROB_destination IP_m32))) IP_m32
				(ite (and (= #b1 (select ROB_busy IP_m33)) (or (= Rtype (select ROB_op IP_m33)) (= SLoad (select ROB_op IP_m33))) (= register (select ROB_destination IP_m33))) IP_m33
				(ite (and (= #b1 (select ROB_busy IP_m34)) (or (= Rtype (select ROB_op IP_m34)) (= SLoad (select ROB_op IP_m34))) (= register (select ROB_destination IP_m34))) IP_m34
				(ite (and (= #b1 (select ROB_busy IP_m35)) (or (= Rtype (select ROB_op IP_m35)) (= SLoad (select ROB_op IP_m35))) (= register (select ROB_destination IP_m35))) IP_m35
				(ite (and (= #b1 (select ROB_busy IP_m36)) (or (= Rtype (select ROB_op IP_m36)) (= SLoad (select ROB_op IP_m36))) (= register (select ROB_destination IP_m36))) IP_m36
				(ite (and (= #b1 (select ROB_busy IP_m37)) (or (= Rtype (select ROB_op IP_m37)) (= SLoad (select ROB_op IP_m37))) (= register (select ROB_destination IP_m37))) IP_m37
				(ite (and (= #b1 (select ROB_busy IP_m38)) (or (= Rtype (select ROB_op IP_m38)) (= SLoad (select ROB_op IP_m38))) (= register (select ROB_destination IP_m38))) IP_m38
				(ite (and (= #b1 (select ROB_busy IP_m39)) (or (= Rtype (select ROB_op IP_m39)) (= SLoad (select ROB_op IP_m39))) (= register (select ROB_destination IP_m39))) IP_m39
				(ite (and (= #b1 (select ROB_busy IP_m40)) (or (= Rtype (select ROB_op IP_m40)) (= SLoad (select ROB_op IP_m40))) (= register (select ROB_destination IP_m40))) IP_m40
                (ite (and (= #b1 (select ROB_busy IP_m41)) (or (= Rtype (select ROB_op IP_m41)) (= SLoad (select ROB_op IP_m41))) (= register (select ROB_destination IP_m41))) IP_m41
				(ite (and (= #b1 (select ROB_busy IP_m42)) (or (= Rtype (select ROB_op IP_m42)) (= SLoad (select ROB_op IP_m42))) (= register (select ROB_destination IP_m42))) IP_m42
				(ite (and (= #b1 (select ROB_busy IP_m43)) (or (= Rtype (select ROB_op IP_m43)) (= SLoad (select ROB_op IP_m43))) (= register (select ROB_destination IP_m43))) IP_m43
				(ite (and (= #b1 (select ROB_busy IP_m44)) (or (= Rtype (select ROB_op IP_m44)) (= SLoad (select ROB_op IP_m44))) (= register (select ROB_destination IP_m44))) IP_m44
				(ite (and (= #b1 (select ROB_busy IP_m45)) (or (= Rtype (select ROB_op IP_m45)) (= SLoad (select ROB_op IP_m45))) (= register (select ROB_destination IP_m45))) IP_m45
				(ite (and (= #b1 (select ROB_busy IP_m46)) (or (= Rtype (select ROB_op IP_m46)) (= SLoad (select ROB_op IP_m46))) (= register (select ROB_destination IP_m46))) IP_m46
				(ite (and (= #b1 (select ROB_busy IP_m47)) (or (= Rtype (select ROB_op IP_m47)) (= SLoad (select ROB_op IP_m47))) (= register (select ROB_destination IP_m47))) IP_m47
				(ite (and (= #b1 (select ROB_busy IP_m48)) (or (= Rtype (select ROB_op IP_m48)) (= SLoad (select ROB_op IP_m48))) (= register (select ROB_destination IP_m48))) IP_m48
				(ite (and (= #b1 (select ROB_busy IP_m49)) (or (= Rtype (select ROB_op IP_m49)) (= SLoad (select ROB_op IP_m49))) (= register (select ROB_destination IP_m49))) IP_m49
				(ite (and (= #b1 (select ROB_busy IP_m50)) (or (= Rtype (select ROB_op IP_m50)) (= SLoad (select ROB_op IP_m50))) (= register (select ROB_destination IP_m50))) IP_m50
                (ite (and (= #b1 (select ROB_busy IP_m51)) (or (= Rtype (select ROB_op IP_m51)) (= SLoad (select ROB_op IP_m51))) (= register (select ROB_destination IP_m51))) IP_m51
				(ite (and (= #b1 (select ROB_busy IP_m52)) (or (= Rtype (select ROB_op IP_m52)) (= SLoad (select ROB_op IP_m52))) (= register (select ROB_destination IP_m52))) IP_m52
				(ite (and (= #b1 (select ROB_busy IP_m53)) (or (= Rtype (select ROB_op IP_m53)) (= SLoad (select ROB_op IP_m53))) (= register (select ROB_destination IP_m53))) IP_m53
				(ite (and (= #b1 (select ROB_busy IP_m54)) (or (= Rtype (select ROB_op IP_m54)) (= SLoad (select ROB_op IP_m54))) (= register (select ROB_destination IP_m54))) IP_m54
				(ite (and (= #b1 (select ROB_busy IP_m55)) (or (= Rtype (select ROB_op IP_m55)) (= SLoad (select ROB_op IP_m55))) (= register (select ROB_destination IP_m55))) IP_m55
				(ite (and (= #b1 (select ROB_busy IP_m56)) (or (= Rtype (select ROB_op IP_m56)) (= SLoad (select ROB_op IP_m56))) (= register (select ROB_destination IP_m56))) IP_m56
				(ite (and (= #b1 (select ROB_busy IP_m57)) (or (= Rtype (select ROB_op IP_m57)) (= SLoad (select ROB_op IP_m57))) (= register (select ROB_destination IP_m57))) IP_m57
				(ite (and (= #b1 (select ROB_busy IP_m58)) (or (= Rtype (select ROB_op IP_m58)) (= SLoad (select ROB_op IP_m58))) (= register (select ROB_destination IP_m58))) IP_m58
				(ite (and (= #b1 (select ROB_busy IP_m59)) (or (= Rtype (select ROB_op IP_m59)) (= SLoad (select ROB_op IP_m59))) (= register (select ROB_destination IP_m59))) IP_m59
				(ite (and (= #b1 (select ROB_busy IP_m60)) (or (= Rtype (select ROB_op IP_m60)) (= SLoad (select ROB_op IP_m60))) (= register (select ROB_destination IP_m60))) IP_m60
                (ite (and (= #b1 (select ROB_busy IP_m61)) (or (= Rtype (select ROB_op IP_m61)) (= SLoad (select ROB_op IP_m61))) (= register (select ROB_destination IP_m61))) IP_m61
				(ite (and (= #b1 (select ROB_busy IP_m62)) (or (= Rtype (select ROB_op IP_m62)) (= SLoad (select ROB_op IP_m62))) (= register (select ROB_destination IP_m62))) IP_m62
				(ite (and (= #b1 (select ROB_busy IP_m63)) (or (= Rtype (select ROB_op IP_m63)) (= SLoad (select ROB_op IP_m63))) (= register (select ROB_destination IP_m63))) IP_m63
				
				
				(_ bv0 6)
				)))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))
			)
		)
	))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))
)


	;---get_addr function, takes rob and LSQ to get the iaddr
(define-fun get_addr ( (ROB_index (_ BitVec 6)) (ROB_done (Array (_ BitVec 6) (_ BitVec 1))) (ROB_op (Array (_ BitVec 6) Int)) (ROB_Maddress (Array (_ BitVec 6) Int)) (LSQ_op (Array (_ BitVec 4) Int)) (LSQ_Vj (Array (_ BitVec 4) Int)) (LSQ_Imm (Array (_ BitVec 4) Int)) (LSQ_ROBdst (Array (_ BitVec 4) (_ BitVec 6)))) Int
	(let
		(
			(LSQ0_op (select LSQ_op (_ bv0 4)))
			(LSQ1_op (select LSQ_op (_ bv1 4)))
			(LSQ2_op (select LSQ_op (_ bv2 4)))
			(LSQ3_op (select LSQ_op (_ bv3 4)))
			(LSQ4_op (select LSQ_op (_ bv4 4)))
			(LSQ5_op (select LSQ_op (_ bv5 4)))
			(LSQ6_op (select LSQ_op (_ bv6 4)))
			(LSQ7_op (select LSQ_op (_ bv7 4)))
			(LSQ8_op (select LSQ_op (_ bv8 4)))
			(LSQ9_op (select LSQ_op (_ bv9 4)))
			(LSQ10_op (select LSQ_op (_ bv10 4)))
			(LSQ11_op (select LSQ_op (_ bv11 4)))
			(LSQ12_op (select LSQ_op (_ bv12 4)))
			(LSQ13_op (select LSQ_op (_ bv13 4)))
			(LSQ14_op (select LSQ_op (_ bv14 4)))
			(LSQ15_op (select LSQ_op (_ bv15 4)))
			
			(LSQ0_vj (select LSQ_Vj (_ bv0 4)))
			(LSQ1_vj (select LSQ_Vj (_ bv1 4)))
			(LSQ2_vj (select LSQ_Vj (_ bv2 4)))
			(LSQ3_vj (select LSQ_Vj (_ bv3 4)))
			(LSQ4_vj (select LSQ_Vj (_ bv4 4)))
			(LSQ5_vj (select LSQ_Vj (_ bv5 4)))
			(LSQ6_vj (select LSQ_Vj (_ bv6 4)))
			(LSQ7_vj (select LSQ_Vj (_ bv7 4)))
			(LSQ8_vj (select LSQ_Vj (_ bv8 4)))
			(LSQ9_vj (select LSQ_Vj (_ bv9 4)))
			(LSQ10_vj (select LSQ_Vj (_ bv10 4)))
			(LSQ11_vj (select LSQ_Vj (_ bv11 4)))
			(LSQ12_vj (select LSQ_Vj (_ bv12 4)))
			(LSQ13_vj (select LSQ_Vj (_ bv13 4)))
			(LSQ14_vj (select LSQ_Vj (_ bv14 4)))
			(LSQ15_vj (select LSQ_Vj (_ bv15 4)))
			
			(LSQ0_Imm (select LSQ_Imm (_ bv0 4)))
			(LSQ1_Imm (select LSQ_Imm (_ bv1 4)))
			(LSQ2_Imm (select LSQ_Imm (_ bv2 4)))
			(LSQ3_Imm (select LSQ_Imm (_ bv3 4)))
			(LSQ4_Imm (select LSQ_Imm (_ bv4 4)))
			(LSQ5_Imm (select LSQ_Imm (_ bv5 4)))
			(LSQ6_Imm (select LSQ_Imm (_ bv6 4)))
			(LSQ7_Imm (select LSQ_Imm (_ bv7 4)))
			(LSQ8_Imm (select LSQ_Imm (_ bv8 4)))
			(LSQ9_Imm (select LSQ_Imm (_ bv9 4)))
			(LSQ10_Imm (select LSQ_Imm (_ bv10 4)))
			(LSQ11_Imm (select LSQ_Imm (_ bv11 4)))
			(LSQ12_Imm (select LSQ_Imm (_ bv12 4)))
			(LSQ13_Imm (select LSQ_Imm (_ bv13 4)))
			(LSQ14_Imm (select LSQ_Imm (_ bv14 4)))
			(LSQ15_Imm (select LSQ_Imm (_ bv15 4)))

			(LSQ0_ROBdst (select LSQ_ROBdst (_ bv0 4)))
			(LSQ1_ROBdst (select LSQ_ROBdst (_ bv1 4)))
			(LSQ2_ROBdst (select LSQ_ROBdst (_ bv2 4)))
			(LSQ3_ROBdst (select LSQ_ROBdst (_ bv3 4)))
			(LSQ4_ROBdst (select LSQ_ROBdst (_ bv4 4)))
			(LSQ5_ROBdst (select LSQ_ROBdst (_ bv5 4)))
			(LSQ6_ROBdst (select LSQ_ROBdst (_ bv6 4)))
			(LSQ7_ROBdst (select LSQ_ROBdst (_ bv7 4)))
			(LSQ8_ROBdst (select LSQ_ROBdst (_ bv8 4)))
			(LSQ9_ROBdst (select LSQ_ROBdst (_ bv9 4)))
			(LSQ10_ROBdst (select LSQ_ROBdst (_ bv10 4)))
			(LSQ11_ROBdst (select LSQ_ROBdst (_ bv11 4)))
			(LSQ12_ROBdst (select LSQ_ROBdst (_ bv12 4)))
			(LSQ13_ROBdst (select LSQ_ROBdst (_ bv13 4)))
			(LSQ14_ROBdst (select LSQ_ROBdst (_ bv14 4)))
			(LSQ15_ROBdst (select LSQ_ROBdst (_ bv15 4)))
		)
	;-- Compute all the addresses
	(let
		(
			(LSQ0_addr (LOAD_Unit LSQ0_vj LSQ0_Imm LSQ0_op))
			(LSQ1_addr (LOAD_Unit LSQ1_vj LSQ1_Imm LSQ1_op))
			(LSQ2_addr (LOAD_Unit LSQ2_vj LSQ2_Imm LSQ2_op))
			(LSQ3_addr (LOAD_Unit LSQ3_vj LSQ3_Imm LSQ3_op))
			(LSQ4_addr (LOAD_Unit LSQ4_vj LSQ4_Imm LSQ4_op))
			(LSQ5_addr (LOAD_Unit LSQ5_vj LSQ5_Imm LSQ5_op))
			(LSQ6_addr (LOAD_Unit LSQ6_vj LSQ6_Imm LSQ6_op))
			(LSQ7_addr (LOAD_Unit LSQ7_vj LSQ7_Imm LSQ7_op))
			(LSQ8_addr (LOAD_Unit LSQ8_vj LSQ8_Imm LSQ8_op))
			(LSQ9_addr (LOAD_Unit LSQ9_vj LSQ9_Imm LSQ9_op))
			(LSQ10_addr (LOAD_Unit LSQ10_vj LSQ10_Imm LSQ10_op))
			(LSQ11_addr (LOAD_Unit LSQ11_vj LSQ11_Imm LSQ11_op))
			(LSQ12_addr (LOAD_Unit LSQ12_vj LSQ12_Imm LSQ12_op))
			(LSQ13_addr (LOAD_Unit LSQ13_vj LSQ13_Imm LSQ13_op))
			(LSQ14_addr (LOAD_Unit LSQ14_vj LSQ14_Imm LSQ14_op))
			(LSQ15_addr (LOAD_Unit LSQ15_vj LSQ15_Imm LSQ15_op))
		)
	;Check the ROB index and LSQ RObdst, pick the one that matches the ROB index
	(let
		(
			(LSQ_Computation
				(ite (= LSQ0_ROBdst ROB_index) LSQ0_addr
				(ite (= LSQ1_ROBdst ROB_index) LSQ1_addr
				(ite (= LSQ2_ROBdst ROB_index) LSQ2_addr
				(ite (= LSQ3_ROBdst ROB_index) LSQ3_addr
				(ite (= LSQ4_ROBdst ROB_index) LSQ4_addr
				(ite (= LSQ5_ROBdst ROB_index) LSQ5_addr
				(ite (= LSQ6_ROBdst ROB_index) LSQ6_addr
				(ite (= LSQ7_ROBdst ROB_index) LSQ7_addr
				(ite (= LSQ8_ROBdst ROB_index) LSQ8_addr
				(ite (= LSQ9_ROBdst ROB_index) LSQ9_addr
				(ite (= LSQ10_ROBdst ROB_index) LSQ10_addr
				(ite (= LSQ11_ROBdst ROB_index) LSQ11_addr
				(ite (= LSQ12_ROBdst ROB_index) LSQ12_addr
				(ite (= LSQ13_ROBdst ROB_index) LSQ13_addr
				(ite (= LSQ14_ROBdst ROB_index) LSQ14_addr
				(ite (= LSQ15_ROBdst ROB_index) LSQ15_addr
				0))))))))))))))))
			)
		)
	(let
		(
			(output 
				(ite (= (select ROB_op ROB_index) SStore)  (select ROB_Maddress ROB_index)
				(ite (and (= (select ROB_op ROB_index) SLoad) (= (select ROB_done ROB_index) #b1))  (select ROB_Maddress ROB_index)
				LSQ_Computation))
			)
		)
	))))
)

;)

;(--------------Visual Declarations-------------
(declare-const T_vis_cache_tag0 (Int))
(declare-const T_vis_cache_tag1 (Int))
(declare-const T_vis_cache_tag2 (Int))
(declare-const T_vis_cache_tag3 (Int))

(declare-const T_vis_cache_valid0 (_ BitVec 1))
(declare-const T_vis_cache_valid1 (_ BitVec 1))
(declare-const T_vis_cache_valid2 (_ BitVec 1))
(declare-const T_vis_cache_valid3 (_ BitVec 1))

(declare-const U4_vis_cache_tag0 (Int))
(declare-const U4_vis_cache_tag1 (Int))
(declare-const U4_vis_cache_tag2 (Int))
(declare-const U4_vis_cache_tag3 (Int))

(declare-const U4_vis_cache_valid0 (_ BitVec 1))
(declare-const U4_vis_cache_valid1 (_ BitVec 1))
(declare-const U4_vis_cache_valid2 (_ BitVec 1))
(declare-const U4_vis_cache_valid3 (_ BitVec 1))


;)

;--========== Processor Start==============
(assert
	(not
;---------------------------Issue------------------------
		(let
			(
				(Instruction (select T_IM T_PC))		;--Fetch
				(PC_plus_one (+ T_PC 1))				;--Increment PC
			)
		(let
			(
				(op (Inst_op Instruction))				;--Instruction decode
				(rs (Inst_rs Instruction))
				(rt (Inst_rt Instruction))
				(rd (Inst_rd Instruction))
				(imm (Inst_imm Instruction))		
				
				(ROB1_busy (select T_ROB_busy (_ bv1 6)))	;--Get Busy values from all locations
				(ROB2_busy (select T_ROB_busy (_ bv2 6)))
				(ROB3_busy (select T_ROB_busy (_ bv3 6)))
				(ROB4_busy (select T_ROB_busy (_ bv4 6)))
				(ROB5_busy (select T_ROB_busy (_ bv5 6)))
				(ROB6_busy (select T_ROB_busy (_ bv6 6)))
				(ROB7_busy (select T_ROB_busy (_ bv7 6)))			
				(ROB8_busy (select T_ROB_busy (_ bv8 6)))
				(ROB9_busy (select T_ROB_busy (_ bv9 6)))
				(ROB10_busy (select T_ROB_busy (_ bv10 6)))
				(ROB11_busy (select T_ROB_busy (_ bv11 6)))
				(ROB12_busy (select T_ROB_busy (_ bv12 6)))
				(ROB13_busy (select T_ROB_busy (_ bv13 6)))
				(ROB14_busy (select T_ROB_busy (_ bv14 6)))
				(ROB15_busy (select T_ROB_busy (_ bv15 6)))
				(ROB16_busy (select T_ROB_busy (_ bv16 6)))
				(ROB17_busy (select T_ROB_busy (_ bv17 6)))
				(ROB18_busy (select T_ROB_busy (_ bv18 6)))
				(ROB19_busy (select T_ROB_busy (_ bv19 6)))
				(ROB20_busy (select T_ROB_busy (_ bv20 6)))
				(ROB21_busy (select T_ROB_busy (_ bv21 6)))
				(ROB22_busy (select T_ROB_busy (_ bv22 6)))
				(ROB23_busy (select T_ROB_busy (_ bv23 6)))
				(ROB24_busy (select T_ROB_busy (_ bv24 6)))
				(ROB25_busy (select T_ROB_busy (_ bv25 6)))
				(ROB26_busy (select T_ROB_busy (_ bv26 6)))
				(ROB27_busy (select T_ROB_busy (_ bv27 6)))
				(ROB28_busy (select T_ROB_busy (_ bv28 6)))
				(ROB29_busy (select T_ROB_busy (_ bv29 6)))
				(ROB30_busy (select T_ROB_busy (_ bv30 6)))
				(ROB31_busy (select T_ROB_busy (_ bv31 6)))
				(ROB32_busy (select T_ROB_busy (_ bv32 6)))
				(ROB33_busy (select T_ROB_busy (_ bv33 6)))
				(ROB34_busy (select T_ROB_busy (_ bv34 6)))
				(ROB35_busy (select T_ROB_busy (_ bv35 6)))
				(ROB36_busy (select T_ROB_busy (_ bv36 6)))
				(ROB37_busy (select T_ROB_busy (_ bv37 6)))
				(ROB38_busy (select T_ROB_busy (_ bv38 6)))
				(ROB39_busy (select T_ROB_busy (_ bv39 6)))
				(ROB40_busy (select T_ROB_busy (_ bv40 6)))
				(ROB41_busy (select T_ROB_busy (_ bv41 6)))
				(ROB42_busy (select T_ROB_busy (_ bv42 6)))
				(ROB43_busy (select T_ROB_busy (_ bv43 6)))
				(ROB44_busy (select T_ROB_busy (_ bv44 6)))
				(ROB45_busy (select T_ROB_busy (_ bv45 6)))
				(ROB46_busy (select T_ROB_busy (_ bv46 6)))
				(ROB47_busy (select T_ROB_busy (_ bv47 6)))
				(ROB48_busy (select T_ROB_busy (_ bv48 6)))
				(ROB49_busy (select T_ROB_busy (_ bv49 6)))
				(ROB50_busy (select T_ROB_busy (_ bv50 6)))
				(ROB51_busy (select T_ROB_busy (_ bv51 6)))
				(ROB52_busy (select T_ROB_busy (_ bv52 6)))
				(ROB53_busy (select T_ROB_busy (_ bv53 6)))
				(ROB54_busy (select T_ROB_busy (_ bv54 6)))
				(ROB55_busy (select T_ROB_busy (_ bv55 6)))
				(ROB56_busy (select T_ROB_busy (_ bv56 6)))
				(ROB57_busy (select T_ROB_busy (_ bv57 6)))
				(ROB58_busy (select T_ROB_busy (_ bv58 6)))
				(ROB59_busy (select T_ROB_busy (_ bv59 6)))
				(ROB60_busy (select T_ROB_busy (_ bv60 6)))
				(ROB61_busy (select T_ROB_busy (_ bv61 6)))
				(ROB62_busy (select T_ROB_busy (_ bv62 6)))
				(ROB63_busy (select T_ROB_busy (_ bv63 6)))



				(RS0_busy (select T_RS_busy (_ bv0 3)))
				(RS1_busy (select T_RS_busy (_ bv1 3)))
				(RS2_busy (select T_RS_busy (_ bv2 3)))
				(RS3_busy (select T_RS_busy (_ bv3 3)))
				(RS4_busy (select T_RS_busy (_ bv4 3)))
				(RS5_busy (select T_RS_busy (_ bv5 3)))
				(RS6_busy (select T_RS_busy (_ bv6 3)))
				(RS7_busy (select T_RS_busy (_ bv7 3)))


				(LSQ0_busy (select T_LSQ_busy (_ bv0 4)))
				(LSQ1_busy (select T_LSQ_busy (_ bv1 4)))
				(LSQ2_busy (select T_LSQ_busy (_ bv2 4)))
				(LSQ3_busy (select T_LSQ_busy (_ bv3 4)))
				(LSQ4_busy (select T_LSQ_busy (_ bv4 4)))
				(LSQ5_busy (select T_LSQ_busy (_ bv5 4)))
				(LSQ6_busy (select T_LSQ_busy (_ bv6 4)))
				(LSQ7_busy (select T_LSQ_busy (_ bv7 4)))	
				(LSQ8_busy (select T_LSQ_busy (_ bv8 4)))
				(LSQ9_busy (select T_LSQ_busy (_ bv9 4)))
				(LSQ10_busy (select T_LSQ_busy (_ bv10 4)))
				(LSQ11_busy (select T_LSQ_busy (_ bv11 4)))
				(LSQ12_busy (select T_LSQ_busy (_ bv12 4)))
				(LSQ13_busy (select T_LSQ_busy (_ bv13 4)))
				(LSQ14_busy (select T_LSQ_busy (_ bv14 4)))
				(LSQ15_busy (select T_LSQ_busy (_ bv15 4)))		
			)
		(let
			(
				(RF_rs (select T_RF rs))	;--Value RF[rs]
				(RF_rt (select T_RF rt))	;--Value RF[rt]
				
				(RAT_rs (RAT T_IP rs T_ROB_busy T_ROB_op T_ROB_destination))	;--Value from RAT for rs
				(RAT_rt (RAT T_IP rt T_ROB_busy T_ROB_op T_ROB_destination))	;--Value from RAT for rt
			)			
		(let
			(
				;-- Stall if manual stall, or if the ROB is full, RS and LSQ check done later 
				(stall
					(ite (= #b1 stall) (_ bv1 1)
					(ite (= #b1 (select T_ROB_busy T_IP)) (_ bv1 1)
					(ite (= #b1 (bvand ROB1_busy ROB2_busy ROB3_busy ROB4_busy ROB5_busy ROB6_busy ROB7_busy ROB8_busy ROB9_busy ROB10_busy ROB11_busy ROB12_busy ROB13_busy ROB14_busy ROB15_busy ROB16_busy ROB17_busy ROB18_busy ROB19_busy ROB20_busy ROB21_busy ROB22_busy ROB23_busy ROB24_busy ROB25_busy ROB26_busy ROB27_busy ROB28_busy ROB29_busy ROB30_busy ROB31_busy ROB32_busy ROB33_busy ROB34_busy ROB35_busy ROB36_busy ROB37_busy ROB38_busy ROB39_busy ROB40_busy ROB41_busy ROB42_busy ROB43_busy ROB44_busy ROB45_busy ROB46_busy ROB47_busy ROB48_busy ROB49_busy ROB50_busy ROB51_busy ROB52_busy ROB53_busy ROB54_busy ROB55_busy ROB56_busy ROB57_busy ROB58_busy ROB59_busy ROB60_busy ROB61_busy ROB62_busy ROB63_busy )) (_ bv1 1)
					(_ bv0 1)
					)))
				)
				;-- RF Destination for Rtype = Rd, Itype = Rt, Branch = Constant(jumping location)
				(RF_destination 
					(ite (= op SLoad) rt
					(ite (= op Rtype) rd
					(ite (= op Branch) imm
					0
					)))
				)
			)			
		;---------Issue to RS or LSQ if there is space and the correct Type------
		(let
			(
				(issue_to_rs0 (ite (and (= RS0_busy #b0) (or (= op Rtype) (= op Branch))) (_ bv1 1) (_ bv0 1)))
				(issue_to_lsq15 (ite (and (= LSQ15_busy #b0) (or (= op SLoad) (= op SStore))) (_ bv1 1) (_ bv0 1)))
			)
		(let
			(
				(issue_to_rs1 (ite (and (= issue_to_rs0 #b0) (= RS1_busy #b0) (or (= op Rtype) (= op Branch))) (_ bv1 1) (_ bv0 1)))
				(issue_to_lsq14 (ite (and (= issue_to_lsq15 #b0) (= LSQ14_busy #b0) (or (= op SLoad) (= op SStore))) (_ bv1 1) (_ bv0 1)))
			)
		(let
			(
				(issue_to_rs2 (ite (and (= issue_to_rs0 #b0) (= issue_to_rs1 #b0) (= RS2_busy #b0) (or (= op Rtype) (= op Branch))) (_ bv1 1) (_ bv0 1)))
				(issue_to_lsq13 (ite (and (= issue_to_lsq14 #b0) (= issue_to_lsq15 #b0) (= LSQ13_busy #b0) (or (= op SLoad) (= op SStore))) (_ bv1 1) (_ bv0 1)))
			)
		(let
			(
				(issue_to_rs3 (ite (and (= issue_to_rs0 #b0) (= issue_to_rs1 #b0) (= issue_to_rs2 #b0) (= RS3_busy #b0) (or (= op Rtype) (= op Branch))) (_ bv1 1) (_ bv0 1)))
				(issue_to_lsq12 (ite (and (= issue_to_lsq13 #b0) (= issue_to_lsq14 #b0) (= issue_to_lsq15 #b0) (= LSQ12_busy #b0) (or (= op SLoad) (= op SStore))) (_ bv1 1) (_ bv0 1)))
			)
		(let
			(
				(issue_to_rs4 (ite (and (= issue_to_rs0 #b0) (= issue_to_rs1 #b0) (= issue_to_rs2 #b0) (= issue_to_rs3 #b0) (= RS4_busy #b0) (or (= op Rtype) (= op Branch))) (_ bv1 1) (_ bv0 1)))
				(issue_to_lsq11 (ite (and (= issue_to_lsq12 #b0) (= issue_to_lsq13 #b0) (= issue_to_lsq14 #b0) (= issue_to_lsq15 #b0) (= LSQ11_busy #b0) (or (= op SLoad) (= op SStore))) (_ bv1 1) (_ bv0 1)))
			)
		(let
			(
				(issue_to_rs5 (ite (and (= issue_to_rs0 #b0) (= issue_to_rs1 #b0) (= issue_to_rs2 #b0) (= issue_to_rs3 #b0) (= issue_to_rs4 #b0) (= RS5_busy #b0) (or (= op Rtype) (= op Branch))) (_ bv1 1) (_ bv0 1)))
				(issue_to_lsq10 (ite (and (= issue_to_lsq11 #b0) (= issue_to_lsq12 #b0) (= issue_to_lsq13 #b0) (= issue_to_lsq14 #b0) (= issue_to_lsq15 #b0) (= LSQ10_busy #b0) (or (= op SLoad) (= op SStore))) (_ bv1 1) (_ bv0 1)))
			)
		(let
			(
				(issue_to_rs6 (ite (and (= issue_to_rs0 #b0) (= issue_to_rs1 #b0) (= issue_to_rs2 #b0) (= issue_to_rs3 #b0) (= issue_to_rs4 #b0) (= issue_to_rs5 #b0) (= RS6_busy #b0) (or (= op Rtype) (= op Branch))) (_ bv1 1) (_ bv0 1)))
				(issue_to_lsq9 (ite (and (= issue_to_lsq10 #b0) (= issue_to_lsq11 #b0) (= issue_to_lsq12 #b0) (= issue_to_lsq13 #b0) (= issue_to_lsq14 #b0) (= issue_to_lsq15 #b0) (= LSQ9_busy #b0) (or (= op SLoad) (= op SStore))) (_ bv1 1) (_ bv0 1)))
			)
		(let
			(
				(issue_to_rs7 (ite (and (= issue_to_rs0 #b0) (= issue_to_rs1 #b0) (= issue_to_rs2 #b0) (= issue_to_rs3 #b0) (= issue_to_rs4 #b0) (= issue_to_rs5 #b0) (= issue_to_rs6 #b0) (= RS7_busy #b0) (or (= op Rtype) (= op Branch))) (_ bv1 1) (_ bv0 1)))
				(issue_to_lsq8 (ite (and (= issue_to_lsq9 #b0) (= issue_to_lsq10 #b0) (= issue_to_lsq11 #b0) (= issue_to_lsq12 #b0) (= issue_to_lsq13 #b0) (= issue_to_lsq14 #b0) (= issue_to_lsq15 #b0) (= LSQ8_busy #b0) (or (= op SLoad) (= op SStore))) (_ bv1 1) (_ bv0 1)))
			)
		(let
			(
				(issue_to_lsq7 (ite (and (= issue_to_lsq8 #b0) (= issue_to_lsq9 #b0) (= issue_to_lsq10 #b0) (= issue_to_lsq11 #b0) (= issue_to_lsq12 #b0) (= issue_to_lsq13 #b0) (= issue_to_lsq14 #b0) (= issue_to_lsq15 #b0) (= LSQ7_busy #b0) (or (= op SLoad) (= op SStore))) (_ bv1 1) (_ bv0 1)))
			)
		(let
			(
				(issue_to_lsq6 (ite (and (= issue_to_lsq7 #b0) (= issue_to_lsq8 #b0) (= issue_to_lsq9 #b0) (= issue_to_lsq10 #b0) (= issue_to_lsq11 #b0) (= issue_to_lsq12 #b0) (= issue_to_lsq13 #b0) (= issue_to_lsq14 #b0) (= issue_to_lsq15 #b0) (= LSQ6_busy #b0) (or (= op SLoad) (= op SStore))) (_ bv1 1) (_ bv0 1)))
			)
		(let
			(
				(issue_to_lsq5 (ite (and (= issue_to_lsq6 #b0) (= issue_to_lsq7 #b0) (= issue_to_lsq8 #b0) (= issue_to_lsq9 #b0) (= issue_to_lsq10 #b0) (= issue_to_lsq11 #b0) (= issue_to_lsq12 #b0) (= issue_to_lsq13 #b0) (= issue_to_lsq14 #b0) (= issue_to_lsq15 #b0) (= LSQ5_busy #b0) (or (= op SLoad) (= op SStore))) (_ bv1 1) (_ bv0 1)))
			)
		(let
			(
				(issue_to_lsq4 (ite (and (= issue_to_lsq5 #b0) (= issue_to_lsq6 #b0) (= issue_to_lsq7 #b0) (= issue_to_lsq8 #b0) (= issue_to_lsq9 #b0) (= issue_to_lsq10 #b0) (= issue_to_lsq11 #b0) (= issue_to_lsq12 #b0) (= issue_to_lsq13 #b0) (= issue_to_lsq14 #b0) (= issue_to_lsq15 #b0) (= LSQ4_busy #b0) (or (= op SLoad) (= op SStore))) (_ bv1 1) (_ bv0 1)))
			)
		(let
			(
				(issue_to_lsq3 (ite (and (= issue_to_lsq4 #b0) (= issue_to_lsq5 #b0) (= issue_to_lsq6 #b0) (= issue_to_lsq7 #b0) (= issue_to_lsq8 #b0) (= issue_to_lsq9 #b0) (= issue_to_lsq10 #b0) (= issue_to_lsq11 #b0) (= issue_to_lsq12 #b0) (= issue_to_lsq13 #b0) (= issue_to_lsq14 #b0) (= issue_to_lsq15 #b0) (= LSQ3_busy #b0) (or (= op SLoad) (= op SStore))) (_ bv1 1) (_ bv0 1)))
			)
		(let
			(
				(issue_to_lsq2 (ite (and (= issue_to_lsq3 #b0) (= issue_to_lsq4 #b0) (= issue_to_lsq5 #b0) (= issue_to_lsq6 #b0) (= issue_to_lsq7 #b0) (= issue_to_lsq8 #b0) (= issue_to_lsq9 #b0) (= issue_to_lsq10 #b0) (= issue_to_lsq11 #b0) (= issue_to_lsq12 #b0) (= issue_to_lsq13 #b0) (= issue_to_lsq14 #b0) (= issue_to_lsq15 #b0) (= LSQ2_busy #b0) (or (= op SLoad) (= op SStore))) (_ bv1 1) (_ bv0 1)))
			)
		(let
			(
				(issue_to_lsq1 (ite (and (= issue_to_lsq2 #b0) (= issue_to_lsq3 #b0) (= issue_to_lsq4 #b0) (= issue_to_lsq5 #b0) (= issue_to_lsq6 #b0) (= issue_to_lsq7 #b0) (= issue_to_lsq8 #b0) (= issue_to_lsq9 #b0) (= issue_to_lsq10 #b0) (= issue_to_lsq11 #b0) (= issue_to_lsq12 #b0) (= issue_to_lsq13 #b0) (= issue_to_lsq14 #b0) (= issue_to_lsq15 #b0) (= LSQ1_busy #b0) (or (= op SLoad) (= op SStore))) (_ bv1 1) (_ bv0 1)))
			)
		(let
			(
				(issue_to_lsq0 (ite (and (= issue_to_lsq1 #b0) (= issue_to_lsq2 #b0) (= issue_to_lsq3 #b0) (= issue_to_lsq4 #b0) (= issue_to_lsq5 #b0) (= issue_to_lsq6 #b0) (= issue_to_lsq7 #b0) (= issue_to_lsq8 #b0) (= issue_to_lsq9 #b0) (= issue_to_lsq10 #b0) (= issue_to_lsq11 #b0) (= issue_to_lsq12 #b0) (= issue_to_lsq13 #b0) (= issue_to_lsq14 #b0) (= issue_to_lsq15 #b0) (= LSQ0_busy #b0) (or (= op SLoad) (= op SStore))) (_ bv1 1) (_ bv0 1)))
			)


		;----------Did it get issued ? and Where did it issue ?
		(let
			(
				(RS_issued (bvor issue_to_rs0 issue_to_rs1 issue_to_rs2 issue_to_rs3 issue_to_rs4 issue_to_rs5 issue_to_rs6 issue_to_rs7))			;-- Did RS issue anything ?
				(LSQ_issued (bvor issue_to_lsq15 issue_to_lsq14 issue_to_lsq13 issue_to_lsq12 issue_to_lsq11 issue_to_lsq10 issue_to_lsq9 issue_to_lsq8 issue_to_lsq7 issue_to_lsq6 issue_to_lsq5 issue_to_lsq4 issue_to_lsq3 issue_to_lsq2 issue_to_lsq1 issue_to_lsq0))
				(RS_Issue_index
					(ite (= issue_to_rs0 #b1) (_ bv0 3)
					(ite (= issue_to_rs1 #b1) (_ bv1 3)
					(ite (= issue_to_rs2 #b1) (_ bv2 3)  
					(ite (= issue_to_rs3 #b1) (_ bv3 3)
					(ite (= issue_to_rs4 #b1) (_ bv4 3) 
					(ite (= issue_to_rs5 #b1) (_ bv5 3) 
					(ite (= issue_to_rs6 #b1) (_ bv6 3) 
					(ite (= issue_to_rs7 #b1) (_ bv7 3)  
					(_ bv0 3)))))))))
				)
				(LSQ_Issue_index 
					(ite (= issue_to_lsq15 #b1) (_ bv15 4)
					(ite (= issue_to_lsq14 #b1) (_ bv14 4)
					(ite (= issue_to_lsq13 #b1) (_ bv13 4)
					(ite (= issue_to_lsq12 #b1) (_ bv12 4)
					(ite (= issue_to_lsq11 #b1) (_ bv11 4)
					(ite (= issue_to_lsq10 #b1) (_ bv10 4)
					(ite (= issue_to_lsq9 #b1) (_ bv9 4)
					(ite (= issue_to_lsq8 #b1) (_ bv8 4) 
					(ite (= issue_to_lsq7 #b1) (_ bv7 4)
					(ite (= issue_to_lsq6 #b1) (_ bv6 4)
					(ite (= issue_to_lsq5 #b1) (_ bv5 4)
					(ite (= issue_to_lsq4 #b1) (_ bv4 4)
					(ite (= issue_to_lsq3 #b1) (_ bv3 4)
					(ite (= issue_to_lsq2 #b1) (_ bv2 4)
					(ite (= issue_to_lsq1 #b1) (_ bv1 4)
					(ite (= issue_to_lsq0 #b1) (_ bv0 4) 
					(_ bv0 4)))))))))))))))))
				)
			)
		;-- Creating Updated states, incase if anything got issued
		(let
			(
				(ROB_busy_update (store T_ROB_busy T_IP (_ bv1 1)))
				(ROB_op_update (store T_ROB_op T_IP op))
				(ROB_destination_update (store T_ROB_destination T_IP RF_destination))
				(ROB_result_update (store T_ROB_result T_IP 0))
				(ROB_exception_update (store T_ROB_exception T_IP (_ bv0 1)))
				(ROB_done_update (store T_ROB_done T_IP (_ bv0 1)))
				(ROB_Maddress_update (store T_ROB_Maddress T_IP 0))
				
				(IP_update (addition T_IP))		;--Incremented Issue Pointer value ROB0 Skipped
				
				(RS_op_update (store T_RS_op RS_Issue_index op))
				(RS_ROB_dst_update (store T_RS_ROB_dst RS_Issue_index T_IP))
				(RS_vj_update (store T_RS_vj RS_Issue_index RF_rs))
				(RS_vk_update (store T_RS_vk RS_Issue_index RF_rt))
				(RS_qj_update (store T_RS_qj RS_Issue_index RAT_rs))
				(RS_qk_update (store T_RS_qk RS_Issue_index RAT_rt))
				(RS_imm_update (store T_RS_imm RS_Issue_index imm))
				(RS_dis_update (store T_RS_dis RS_Issue_index (_ bv0 1)))
				(RS_busy_update (store T_RS_busy RS_Issue_index (_ bv1 1)))
				
				(LSQ_op_update (store T_LSQ_op LSQ_Issue_index op))
				(LSQ_ROB_dst_update (store T_LSQ_ROB_dst LSQ_Issue_index T_IP))
				(LSQ_vj_update (store T_LSQ_vj LSQ_Issue_index RF_rs))
				(LSQ_vk_update (store T_LSQ_vk LSQ_Issue_index RF_rt))
				(LSQ_qj_update (store T_LSQ_qj LSQ_Issue_index RAT_rs))
				(LSQ_qk_update (store T_LSQ_qk LSQ_Issue_index RAT_rt))
				(LSQ_imm_update (store T_LSQ_imm LSQ_Issue_index imm))
				(LSQ_dis_update (store T_LSQ_dis LSQ_Issue_index (_ bv0 1)))
				(LSQ_busy_update (store T_LSQ_busy LSQ_Issue_index (_ bv1 1)))
			)			
		;-- If issue took place then next state (U1) will get the updated values, else same as previous state
		;-- Note that some values do no change (RF, DM, CP, Cache...) they just transition as is to U1
		(let
			(
				(U1_RF (ite (and (= stall #b0) (or (= RS_issued #b1) (= LSQ_issued #b1))) T_RF T_RF))
				(U1_DM (ite (and (= stall #b0) (or (= RS_issued #b1) (= LSQ_issued #b1))) T_DM T_DM))
				
				(U1_CacheL1_Tag (ite (and (= stall #b0) (or (= RS_issued #b1) (= LSQ_issued #b1))) T_Cache_Tag T_Cache_Tag))
				(U1_CacheL1_Data (ite (and (= stall #b0) (or (= RS_issued #b1) (= LSQ_issued #b1))) T_Cache_Data T_Cache_Data))
				(U1_CacheL1_Valid (ite (and (= stall #b0) (or (= RS_issued #b1) (= LSQ_issued #b1))) T_Cache_Valid T_Cache_Valid))
				
				(U1_PC (ite (and (= stall #b0) (or (= RS_issued #b1) (= LSQ_issued #b1))) PC_plus_one T_PC))
				
				(U1_IP (ite (and (= stall #b0) (or (= RS_issued #b1) (= LSQ_issued #b1))) IP_update T_IP))
				(U1_CP (ite (and (= stall #b0) (or (= RS_issued #b1) (= LSQ_issued #b1))) T_CP T_CP))
				
				(U1_ROB_busy (ite (and (= stall #b0) (or (= RS_issued #b1) (= LSQ_issued #b1))) ROB_busy_update T_ROB_busy))
				(U1_ROB_op (ite (and (= stall #b0) (or (= RS_issued #b1) (= LSQ_issued #b1))) ROB_op_update T_ROB_op))
				(U1_ROB_destination (ite (and (= stall #b0) (or (= RS_issued #b1) (= LSQ_issued #b1))) ROB_destination_update T_ROB_destination))
				(U1_ROB_result (ite (and (= stall #b0) (or (= RS_issued #b1) (= LSQ_issued #b1))) ROB_result_update T_ROB_result))
				(U1_ROB_exception (ite (and (= stall #b0) (or (= RS_issued #b1) (= LSQ_issued #b1))) ROB_exception_update T_ROB_exception))
				(U1_ROB_done (ite (and (= stall #b0) (or (= RS_issued #b1) (= LSQ_issued #b1))) ROB_done_update T_ROB_done))
				(U1_ROB_Maddress (ite (and (= stall #b0) (or (= RS_issued #b1) (= LSQ_issued #b1))) ROB_Maddress_update T_ROB_Maddress))
				
				(U1_RS_op (ite (and (= stall #b0) (= RS_issued #b1)) RS_op_update T_RS_op))
				(U1_RS_ROB_dst (ite (and (= stall #b0) (= RS_issued #b1)) RS_ROB_dst_update T_RS_ROB_dst))
				(U1_RS_vj (ite (and (= stall #b0) (= RS_issued #b1)) RS_vj_update T_RS_vj))
				(U1_RS_vk (ite (and (= stall #b0) (= RS_issued #b1)) RS_vk_update T_RS_vk))
				(U1_RS_qj (ite (and (= stall #b0) (= RS_issued #b1)) RS_qj_update T_RS_qj))
				(U1_RS_qk (ite (and (= stall #b0) (= RS_issued #b1)) RS_qk_update T_RS_qk))
				(U1_RS_imm (ite (and (= stall #b0) (= RS_issued #b1)) RS_imm_update T_RS_imm))
				(U1_RS_dis (ite (and (= stall #b0) (= RS_issued #b1)) RS_dis_update T_RS_dis))
				(U1_RS_busy (ite (and (= stall #b0) (= RS_issued #b1)) RS_busy_update T_RS_busy))
				
				(U1_LSQ_op (ite (and (= stall #b0) (= LSQ_issued #b1)) LSQ_op_update T_LSQ_op))
				(U1_LSQ_ROB_dst (ite (and (= stall #b0) (= LSQ_issued #b1)) LSQ_ROB_dst_update T_LSQ_ROB_dst))
				(U1_LSQ_vj (ite (and (= stall #b0) (= LSQ_issued #b1)) LSQ_vj_update T_LSQ_vj))
				(U1_LSQ_vk (ite (and (= stall #b0) (= LSQ_issued #b1)) LSQ_vk_update T_LSQ_vk))
				(U1_LSQ_qj (ite (and (= stall #b0) (= LSQ_issued #b1)) LSQ_qj_update T_LSQ_qj))
				(U1_LSQ_qk (ite (and (= stall #b0) (= LSQ_issued #b1)) LSQ_qk_update T_LSQ_qk))
				(U1_LSQ_imm (ite (and (= stall #b0) (= LSQ_issued #b1)) LSQ_imm_update T_LSQ_imm))
				(U1_LSQ_dis (ite (and (= stall #b0) (= LSQ_issued #b1)) LSQ_dis_update T_LSQ_dis))
				(U1_LSQ_busy (ite (and (= stall #b0) (= LSQ_issued #b1)) LSQ_busy_update T_LSQ_busy))
			)			
;---------------------------Update------------------------
;-- Check RS/LSQ Tags with ROB results, update value if possible
;-- Update dispatch bits in RS and LSQ			
		;-- Get all the RS and LSQ locations busy and tag values
		(let
			(
				(U1_RS0_busy (select U1_RS_busy (_ bv0 3)))
				(U1_RS0_qj (select U1_RS_qj (_ bv0 3)))
				(U1_RS0_qk (select U1_RS_qk (_ bv0 3)))
				(U1_RS1_busy (select U1_RS_busy (_ bv1 3)))
				(U1_RS1_qj (select U1_RS_qj (_ bv1 3)))
				(U1_RS1_qk (select U1_RS_qk (_ bv1 3)))
				(U1_RS2_busy (select U1_RS_busy (_ bv2 3)))
				(U1_RS2_qj (select U1_RS_qj (_ bv2 3)))
				(U1_RS2_qk (select U1_RS_qk (_ bv2 3)))
				(U1_RS3_busy (select U1_RS_busy (_ bv3 3)))
				(U1_RS3_qj (select U1_RS_qj (_ bv3 3)))
				(U1_RS3_qk (select U1_RS_qk (_ bv3 3)))
                (U1_RS4_busy (select U1_RS_busy (_ bv4 3)))
				(U1_RS4_qj (select U1_RS_qj (_ bv4 3)))
				(U1_RS4_qk (select U1_RS_qk (_ bv4 3)))
				(U1_RS5_busy (select U1_RS_busy (_ bv5 3)))
				(U1_RS5_qj (select U1_RS_qj (_ bv5 3)))
				(U1_RS5_qk (select U1_RS_qk (_ bv5 3)))
				(U1_RS6_busy (select U1_RS_busy (_ bv6 3)))
				(U1_RS6_qj (select U1_RS_qj (_ bv6 3)))
				(U1_RS6_qk (select U1_RS_qk (_ bv6 3)))
				(U1_RS7_busy (select U1_RS_busy (_ bv7 3)))
				(U1_RS7_qj (select U1_RS_qj (_ bv7 3)))
				(U1_RS7_qk (select U1_RS_qk (_ bv7 3)))

				
				(U1_LSQ0_busy (select U1_LSQ_busy (_ bv0 4)))
				(U1_LSQ0_qj (select U1_LSQ_qj (_ bv0 4)))
				(U1_LSQ0_qk (select U1_LSQ_qk (_ bv0 4)))
				(U1_LSQ1_busy (select U1_LSQ_busy (_ bv1 4)))
				(U1_LSQ1_qj (select U1_LSQ_qj (_ bv1 4)))
				(U1_LSQ1_qk (select U1_LSQ_qk (_ bv1 4)))
				(U1_LSQ2_busy (select U1_LSQ_busy (_ bv2 4)))
				(U1_LSQ2_qj (select U1_LSQ_qj (_ bv2 4)))
				(U1_LSQ2_qk (select U1_LSQ_qk (_ bv2 4)))
				(U1_LSQ3_busy (select U1_LSQ_busy (_ bv3 4)))
				(U1_LSQ3_qj (select U1_LSQ_qj (_ bv3 4)))
				(U1_LSQ3_qk (select U1_LSQ_qk (_ bv3 4)))
				(U1_LSQ4_busy (select U1_LSQ_busy (_ bv4 4)))
				(U1_LSQ4_qj (select U1_LSQ_qj (_ bv4 4)))
				(U1_LSQ4_qk (select U1_LSQ_qk (_ bv4 4)))
				(U1_LSQ5_busy (select U1_LSQ_busy (_ bv5 4)))
				(U1_LSQ5_qj (select U1_LSQ_qj (_ bv5 4)))
				(U1_LSQ5_qk (select U1_LSQ_qk (_ bv5 4)))
				(U1_LSQ6_busy (select U1_LSQ_busy (_ bv6 4)))
				(U1_LSQ6_qj (select U1_LSQ_qj (_ bv6 4)))
				(U1_LSQ6_qk (select U1_LSQ_qk (_ bv6 4)))
				(U1_LSQ7_busy (select U1_LSQ_busy (_ bv7 4)))
				(U1_LSQ7_qj (select U1_LSQ_qj (_ bv7 4)))
				(U1_LSQ7_qk (select U1_LSQ_qk (_ bv7 4)))
				(U1_LSQ8_busy (select U1_LSQ_busy (_ bv8 4)))
				(U1_LSQ8_qj (select U1_LSQ_qj (_ bv8 4)))
				(U1_LSQ8_qk (select U1_LSQ_qk (_ bv8 4)))
				(U1_LSQ9_busy (select U1_LSQ_busy (_ bv9 4)))
				(U1_LSQ9_qj (select U1_LSQ_qj (_ bv9 4)))
				(U1_LSQ9_qk (select U1_LSQ_qk (_ bv9 4)))
				(U1_LSQ10_busy (select U1_LSQ_busy (_ bv10 4)))
				(U1_LSQ10_qj (select U1_LSQ_qj (_ bv10 4)))
				(U1_LSQ10_qk (select U1_LSQ_qk (_ bv10 4)))
				(U1_LSQ11_busy (select U1_LSQ_busy (_ bv11 4)))
				(U1_LSQ11_qj (select U1_LSQ_qj (_ bv11 4)))
				(U1_LSQ11_qk (select U1_LSQ_qk (_ bv11 4)))
				(U1_LSQ12_busy (select U1_LSQ_busy (_ bv12 4)))
				(U1_LSQ12_qj (select U1_LSQ_qj (_ bv12 4)))
				(U1_LSQ12_qk (select U1_LSQ_qk (_ bv12 4)))
				(U1_LSQ13_busy (select U1_LSQ_busy (_ bv13 4)))
				(U1_LSQ13_qj (select U1_LSQ_qj (_ bv13 4)))
				(U1_LSQ13_qk (select U1_LSQ_qk (_ bv13 4)))
				(U1_LSQ14_busy (select U1_LSQ_busy (_ bv14 4)))
				(U1_LSQ14_qj (select U1_LSQ_qj (_ bv14 4)))
				(U1_LSQ14_qk (select U1_LSQ_qk (_ bv14 4)))
				(U1_LSQ15_busy (select U1_LSQ_busy (_ bv15 4)))
				(U1_LSQ15_qj (select U1_LSQ_qj (_ bv15 4)))
				(U1_LSQ15_qk (select U1_LSQ_qk (_ bv15 4)))
			)			
		;-- Using the Tags from RS and LSQ, fetch the ROB done and result values
		(let
			(
				(U1_RS0_qj_ROB_done (select U1_ROB_done U1_RS0_qj))
				(U1_RS0_qj_ROB_result (select U1_ROB_result U1_RS0_qj))
				(U1_RS0_qk_ROB_done (select U1_ROB_done U1_RS0_qk))
				(U1_RS0_qk_ROB_result (select U1_ROB_result U1_RS0_qk))
				(U1_RS1_qj_ROB_done (select U1_ROB_done U1_RS1_qj))
				(U1_RS1_qj_ROB_result (select U1_ROB_result U1_RS1_qj))
				(U1_RS1_qk_ROB_done (select U1_ROB_done U1_RS1_qk))
				(U1_RS1_qk_ROB_result (select U1_ROB_result U1_RS1_qk))
				(U1_RS2_qj_ROB_done (select U1_ROB_done U1_RS2_qj))
				(U1_RS2_qj_ROB_result (select U1_ROB_result U1_RS2_qj))
				(U1_RS2_qk_ROB_done (select U1_ROB_done U1_RS2_qk))
				(U1_RS2_qk_ROB_result (select U1_ROB_result U1_RS2_qk))
				(U1_RS3_qj_ROB_done (select U1_ROB_done U1_RS3_qj))
				(U1_RS3_qj_ROB_result (select U1_ROB_result U1_RS3_qj))
				(U1_RS3_qk_ROB_done (select U1_ROB_done U1_RS3_qk))
				(U1_RS3_qk_ROB_result (select U1_ROB_result U1_RS3_qk))
				(U1_RS4_qj_ROB_done (select U1_ROB_done U1_RS4_qj))
				(U1_RS4_qj_ROB_result (select U1_ROB_result U1_RS4_qj))
				(U1_RS4_qk_ROB_done (select U1_ROB_done U1_RS4_qk))
				(U1_RS4_qk_ROB_result (select U1_ROB_result U1_RS4_qk))
				(U1_RS5_qj_ROB_done (select U1_ROB_done U1_RS5_qj))
				(U1_RS5_qj_ROB_result (select U1_ROB_result U1_RS5_qj))
				(U1_RS5_qk_ROB_done (select U1_ROB_done U1_RS5_qk))
				(U1_RS5_qk_ROB_result (select U1_ROB_result U1_RS5_qk))
				(U1_RS6_qj_ROB_done (select U1_ROB_done U1_RS6_qj))
				(U1_RS6_qj_ROB_result (select U1_ROB_result U1_RS6_qj))
				(U1_RS6_qk_ROB_done (select U1_ROB_done U1_RS6_qk))
				(U1_RS6_qk_ROB_result (select U1_ROB_result U1_RS6_qk))
				(U1_RS7_qj_ROB_done (select U1_ROB_done U1_RS7_qj))
				(U1_RS7_qj_ROB_result (select U1_ROB_result U1_RS7_qj))
				(U1_RS7_qk_ROB_done (select U1_ROB_done U1_RS7_qk))
				(U1_RS7_qk_ROB_result (select U1_ROB_result U1_RS7_qk))
				
				(U1_LSQ0_qj_ROB_done (select U1_ROB_done U1_LSQ0_qj))
				(U1_LSQ0_qj_ROB_result (select U1_ROB_result U1_LSQ0_qj))
				(U1_LSQ0_qk_ROB_done (select U1_ROB_done U1_LSQ0_qk))
				(U1_LSQ0_qk_ROB_result (select U1_ROB_result U1_LSQ0_qk))
				(U1_LSQ1_qj_ROB_done (select U1_ROB_done U1_LSQ1_qj))
				(U1_LSQ1_qj_ROB_result (select U1_ROB_result U1_LSQ1_qj))
				(U1_LSQ1_qk_ROB_done (select U1_ROB_done U1_LSQ1_qk))
				(U1_LSQ1_qk_ROB_result (select U1_ROB_result U1_LSQ1_qk))
				(U1_LSQ2_qj_ROB_done (select U1_ROB_done U1_LSQ2_qj))
				(U1_LSQ2_qj_ROB_result (select U1_ROB_result U1_LSQ2_qj))
				(U1_LSQ2_qk_ROB_done (select U1_ROB_done U1_LSQ2_qk))
				(U1_LSQ2_qk_ROB_result (select U1_ROB_result U1_LSQ2_qk))
				(U1_LSQ3_qj_ROB_done (select U1_ROB_done U1_LSQ3_qj))
				(U1_LSQ3_qj_ROB_result (select U1_ROB_result U1_LSQ3_qj))
				(U1_LSQ3_qk_ROB_done (select U1_ROB_done U1_LSQ3_qk))
				(U1_LSQ3_qk_ROB_result (select U1_ROB_result U1_LSQ3_qk))
                (U1_LSQ4_qj_ROB_done (select U1_ROB_done U1_LSQ4_qj))
				(U1_LSQ4_qj_ROB_result (select U1_ROB_result U1_LSQ4_qj))
				(U1_LSQ4_qk_ROB_done (select U1_ROB_done U1_LSQ4_qk))
				(U1_LSQ4_qk_ROB_result (select U1_ROB_result U1_LSQ4_qk))
				(U1_LSQ5_qj_ROB_done (select U1_ROB_done U1_LSQ5_qj))
				(U1_LSQ5_qj_ROB_result (select U1_ROB_result U1_LSQ5_qj))
				(U1_LSQ5_qk_ROB_done (select U1_ROB_done U1_LSQ5_qk))
				(U1_LSQ5_qk_ROB_result (select U1_ROB_result U1_LSQ5_qk))
				(U1_LSQ6_qj_ROB_done (select U1_ROB_done U1_LSQ6_qj))
				(U1_LSQ6_qj_ROB_result (select U1_ROB_result U1_LSQ6_qj))
				(U1_LSQ6_qk_ROB_done (select U1_ROB_done U1_LSQ6_qk))
				(U1_LSQ6_qk_ROB_result (select U1_ROB_result U1_LSQ6_qk))
				(U1_LSQ7_qj_ROB_done (select U1_ROB_done U1_LSQ7_qj))
				(U1_LSQ7_qj_ROB_result (select U1_ROB_result U1_LSQ7_qj))
				(U1_LSQ7_qk_ROB_done (select U1_ROB_done U1_LSQ7_qk))
				(U1_LSQ7_qk_ROB_result (select U1_ROB_result U1_LSQ7_qk))
				(U1_LSQ8_qj_ROB_done (select U1_ROB_done U1_LSQ8_qj))
				(U1_LSQ8_qj_ROB_result (select U1_ROB_result U1_LSQ8_qj))
				(U1_LSQ8_qk_ROB_done (select U1_ROB_done U1_LSQ8_qk))
				(U1_LSQ8_qk_ROB_result (select U1_ROB_result U1_LSQ8_qk))
				(U1_LSQ9_qj_ROB_done (select U1_ROB_done U1_LSQ9_qj))
				(U1_LSQ9_qj_ROB_result (select U1_ROB_result U1_LSQ9_qj))
				(U1_LSQ9_qk_ROB_done (select U1_ROB_done U1_LSQ9_qk))
				(U1_LSQ9_qk_ROB_result (select U1_ROB_result U1_LSQ9_qk))
				(U1_LSQ10_qj_ROB_done (select U1_ROB_done U1_LSQ10_qj))
				(U1_LSQ10_qj_ROB_result (select U1_ROB_result U1_LSQ10_qj))
				(U1_LSQ10_qk_ROB_done (select U1_ROB_done U1_LSQ10_qk))
				(U1_LSQ10_qk_ROB_result (select U1_ROB_result U1_LSQ10_qk))
				(U1_LSQ11_qj_ROB_done (select U1_ROB_done U1_LSQ11_qj))
				(U1_LSQ11_qj_ROB_result (select U1_ROB_result U1_LSQ11_qj))
				(U1_LSQ11_qk_ROB_done (select U1_ROB_done U1_LSQ11_qk))
				(U1_LSQ11_qk_ROB_result (select U1_ROB_result U1_LSQ11_qk))
                (U1_LSQ12_qj_ROB_done (select U1_ROB_done U1_LSQ12_qj))
				(U1_LSQ12_qj_ROB_result (select U1_ROB_result U1_LSQ12_qj))
				(U1_LSQ12_qk_ROB_done (select U1_ROB_done U1_LSQ12_qk))
				(U1_LSQ12_qk_ROB_result (select U1_ROB_result U1_LSQ12_qk))
				(U1_LSQ13_qj_ROB_done (select U1_ROB_done U1_LSQ13_qj))
				(U1_LSQ13_qj_ROB_result (select U1_ROB_result U1_LSQ13_qj))
				(U1_LSQ13_qk_ROB_done (select U1_ROB_done U1_LSQ13_qk))
				(U1_LSQ13_qk_ROB_result (select U1_ROB_result U1_LSQ13_qk))
				(U1_LSQ14_qj_ROB_done (select U1_ROB_done U1_LSQ14_qj))
				(U1_LSQ14_qj_ROB_result (select U1_ROB_result U1_LSQ14_qj))
				(U1_LSQ14_qk_ROB_done (select U1_ROB_done U1_LSQ14_qk))
				(U1_LSQ14_qk_ROB_result (select U1_ROB_result U1_LSQ14_qk))
				(U1_LSQ15_qj_ROB_done (select U1_ROB_done U1_LSQ15_qj))
				(U1_LSQ15_qj_ROB_result (select U1_ROB_result U1_LSQ15_qj))
				(U1_LSQ15_qk_ROB_done (select U1_ROB_done U1_LSQ15_qk))
				(U1_LSQ15_qk_ROB_result (select U1_ROB_result U1_LSQ15_qk))

			)			

		;-- Creating RS0's and LSQ0's potential updated state
		(let
			(
				(U1_RS0_vj_update (store U1_RS_vj (_ bv0 3) U1_RS0_qj_ROB_result))
				(U1_RS0_vk_update (store U1_RS_vk (_ bv0 3) U1_RS0_qk_ROB_result))					
				(U1_RS0_qj_update (store U1_RS_qj (_ bv0 3) (_ bv0 6)))	
				(U1_RS0_qk_update (store U1_RS_qk (_ bv0 3) (_ bv0 6)))	
				(U1_LSQ0_vj_update (store U1_LSQ_vj (_ bv0 4) U1_LSQ0_qj_ROB_result))	
				(U1_LSQ0_vk_update (store U1_LSQ_vk (_ bv0 4) U1_LSQ0_qk_ROB_result))	
				(U1_LSQ0_qj_update (store U1_LSQ_qj (_ bv0 4) (_ bv0 6)))	
				(U1_LSQ0_qk_update (store U1_LSQ_qk (_ bv0 4) (_ bv0 6)))	
			)			
		;-- If Location is busy, tag is not 0, and ROB is done then give the value to the entry
		(let
			(
				(U2_RS_vj (ite (and (= #b1 U1_RS0_busy) (not (= #b000000 U1_RS0_qj)) (= #b1 U1_RS0_qj_ROB_done)) U1_RS0_vj_update U1_RS_vj))
				(U2_RS_vk (ite (and (= #b1 U1_RS0_busy) (not (= #b000000 U1_RS0_qk)) (= #b1 U1_RS0_qk_ROB_done)) U1_RS0_vk_update U1_RS_vk))
				(U2_RS_qj (ite (and (= #b1 U1_RS0_busy) (not (= #b000000 U1_RS0_qj)) (= #b1 U1_RS0_qj_ROB_done)) U1_RS0_qj_update U1_RS_qj))
				(U2_RS_qk (ite (and (= #b1 U1_RS0_busy) (not (= #b000000 U1_RS0_qk)) (= #b1 U1_RS0_qk_ROB_done)) U1_RS0_qk_update U1_RS_qk))
				(U2_LSQ_vj (ite (and (= #b1 U1_LSQ0_busy) (not (= #b000000 U1_LSQ0_qj)) (= #b1 U1_LSQ0_qj_ROB_done)) U1_LSQ0_vj_update U1_LSQ_vj))
				(U2_LSQ_vk (ite (and (= #b1 U1_LSQ0_busy) (not (= #b000000 U1_LSQ0_qk)) (= #b1 U1_LSQ0_qk_ROB_done)) U1_LSQ0_vk_update U1_LSQ_vk))
				(U2_LSQ_qj (ite (and (= #b1 U1_LSQ0_busy) (not (= #b000000 U1_LSQ0_qj)) (= #b1 U1_LSQ0_qj_ROB_done)) U1_LSQ0_qj_update U1_LSQ_qj))
				(U2_LSQ_qk (ite (and (= #b1 U1_LSQ0_busy) (not (= #b000000 U1_LSQ0_qk)) (= #b1 U1_LSQ0_qk_ROB_done)) U1_LSQ0_qk_update U1_LSQ_qk))
			)			
		;-- Creating RS1's and LSQ1's potential updated state, updating if required
		(let
			(
				(U1_RS1_vj_update (store U2_RS_vj (_ bv1 3) U1_RS1_qj_ROB_result))	
				(U1_RS1_vk_update (store U2_RS_vk (_ bv1 3) U1_RS1_qk_ROB_result))	
				(U1_RS1_qj_update (store U2_RS_qj (_ bv1 3) (_ bv0 6)))	
				(U1_RS1_qk_update (store U2_RS_qk (_ bv1 3) (_ bv0 6)))	
				(U1_LSQ1_vj_update (store U2_LSQ_vj (_ bv1 4) U1_LSQ1_qj_ROB_result))	
				(U1_LSQ1_vk_update (store U2_LSQ_vk (_ bv1 4) U1_LSQ1_qk_ROB_result))	
				(U1_LSQ1_qj_update (store U2_LSQ_qj (_ bv1 4) (_ bv0 6)))	
				(U1_LSQ1_qk_update (store U2_LSQ_qk (_ bv1 4) (_ bv0 6)))	
			)
		(let
			(
				(U2_RS_vj (ite (and (= #b1 U1_RS1_busy) (not (= #b000000 U1_RS1_qj)) (= #b1 U1_RS1_qj_ROB_done)) U1_RS1_vj_update U1_RS_vj))
				(U2_RS_vk (ite (and (= #b1 U1_RS1_busy) (not (= #b000000 U1_RS1_qk)) (= #b1 U1_RS1_qk_ROB_done)) U1_RS1_vk_update U1_RS_vk))
				(U2_RS_qj (ite (and (= #b1 U1_RS1_busy) (not (= #b000000 U1_RS1_qj)) (= #b1 U1_RS1_qj_ROB_done)) U1_RS1_qj_update U1_RS_qj))
				(U2_RS_qk (ite (and (= #b1 U1_RS1_busy) (not (= #b000000 U1_RS1_qk)) (= #b1 U1_RS1_qk_ROB_done)) U1_RS1_qk_update U1_RS_qk))
				(U2_LSQ_vj (ite (and (= #b1 U1_LSQ1_busy) (not (= #b000000 U1_LSQ1_qj)) (= #b1 U1_LSQ1_qj_ROB_done)) U1_LSQ1_vj_update U1_LSQ_vj))
				(U2_LSQ_vk (ite (and (= #b1 U1_LSQ1_busy) (not (= #b000000 U1_LSQ1_qk)) (= #b1 U1_LSQ1_qk_ROB_done)) U1_LSQ1_vk_update U1_LSQ_vk))
				(U2_LSQ_qj (ite (and (= #b1 U1_LSQ1_busy) (not (= #b000000 U1_LSQ1_qj)) (= #b1 U1_LSQ1_qj_ROB_done)) U1_LSQ1_qj_update U1_LSQ_qj))
				(U2_LSQ_qk (ite (and (= #b1 U1_LSQ1_busy) (not (= #b000000 U1_LSQ1_qk)) (= #b1 U1_LSQ1_qk_ROB_done)) U1_LSQ1_qk_update U1_LSQ_qk))
			)			
		;-- Creating RS2's and LSQ2's potential updated state, updating if required
		(let
			(
				(U1_RS2_vj_update (store U2_RS_vj (_ bv2 3) U1_RS2_qj_ROB_result))	
				(U1_RS2_vk_update (store U2_RS_vk (_ bv2 3) U1_RS2_qk_ROB_result))	
				(U1_RS2_qj_update (store U2_RS_qj (_ bv2 3) (_ bv0 6)))	
				(U1_RS2_qk_update (store U2_RS_qk (_ bv2 3) (_ bv0 6)))	
				(U1_LSQ2_vj_update (store U2_LSQ_vj (_ bv2 4) U1_LSQ2_qj_ROB_result))	
				(U1_LSQ2_vk_update (store U2_LSQ_vk (_ bv2 4) U1_LSQ2_qk_ROB_result))	
				(U1_LSQ2_qj_update (store U2_LSQ_qj (_ bv2 4) (_ bv0 6)))	
				(U1_LSQ2_qk_update (store U2_LSQ_qk (_ bv2 4) (_ bv0 6)))	
			)
		(let
			(
				(U2_RS_vj (ite (and (= #b1 U1_RS2_busy) (not (= #b000000 U1_RS2_qj)) (= #b1 U1_RS2_qj_ROB_done)) U1_RS2_vj_update U1_RS_vj))
				(U2_RS_vk (ite (and (= #b1 U1_RS2_busy) (not (= #b000000 U1_RS2_qk)) (= #b1 U1_RS2_qk_ROB_done)) U1_RS2_vk_update U1_RS_vk))
				(U2_RS_qj (ite (and (= #b1 U1_RS2_busy) (not (= #b000000 U1_RS2_qj)) (= #b1 U1_RS2_qj_ROB_done)) U1_RS2_qj_update U1_RS_qj))
				(U2_RS_qk (ite (and (= #b1 U1_RS2_busy) (not (= #b000000 U1_RS2_qk)) (= #b1 U1_RS2_qk_ROB_done)) U1_RS2_qk_update U1_RS_qk))
				(U2_LSQ_vj (ite (and (= #b1 U1_LSQ2_busy) (not (= #b000000 U1_LSQ2_qj)) (= #b1 U1_LSQ2_qj_ROB_done)) U1_LSQ2_vj_update U1_LSQ_vj))
				(U2_LSQ_vk (ite (and (= #b1 U1_LSQ2_busy) (not (= #b000000 U1_LSQ2_qk)) (= #b1 U1_LSQ2_qk_ROB_done)) U1_LSQ2_vk_update U1_LSQ_vk))
				(U2_LSQ_qj (ite (and (= #b1 U1_LSQ2_busy) (not (= #b000000 U1_LSQ2_qj)) (= #b1 U1_LSQ2_qj_ROB_done)) U1_LSQ2_qj_update U1_LSQ_qj))
				(U2_LSQ_qk (ite (and (= #b1 U1_LSQ2_busy) (not (= #b000000 U1_LSQ2_qk)) (= #b1 U1_LSQ2_qk_ROB_done)) U1_LSQ2_qk_update U1_LSQ_qk))
			)			
		;-- Creating RS3's and LSQ3's potential updated state, updating if required
		(let
			(
				(U1_RS3_vj_update (store U2_RS_vj (_ bv3 3) U1_RS3_qj_ROB_result))	
				(U1_RS3_vk_update (store U2_RS_vk (_ bv3 3) U1_RS3_qk_ROB_result))	
				(U1_RS3_qj_update (store U2_RS_qj (_ bv3 3) (_ bv0 6)))	
				(U1_RS3_qk_update (store U2_RS_qk (_ bv3 3) (_ bv0 6)))	
				(U1_LSQ3_vj_update (store U2_LSQ_vj (_ bv3 4) U1_LSQ3_qj_ROB_result))	
				(U1_LSQ3_vk_update (store U2_LSQ_vk (_ bv3 4) U1_LSQ3_qk_ROB_result))	
				(U1_LSQ3_qj_update (store U2_LSQ_qj (_ bv3 4) (_ bv0 6)))	
				(U1_LSQ3_qk_update (store U2_LSQ_qk (_ bv3 4) (_ bv0 6)))	
			)
		(let
			(
				(U2_RS_vj (ite (and (= #b1 U1_RS3_busy) (not (= #b000000 U1_RS3_qj)) (= #b1 U1_RS3_qj_ROB_done)) U1_RS3_vj_update U1_RS_vj))
				(U2_RS_vk (ite (and (= #b1 U1_RS3_busy) (not (= #b000000 U1_RS3_qk)) (= #b1 U1_RS3_qk_ROB_done)) U1_RS3_vk_update U1_RS_vk))
				(U2_RS_qj (ite (and (= #b1 U1_RS3_busy) (not (= #b000000 U1_RS3_qj)) (= #b1 U1_RS3_qj_ROB_done)) U1_RS3_qj_update U1_RS_qj))
				(U2_RS_qk (ite (and (= #b1 U1_RS3_busy) (not (= #b000000 U1_RS3_qk)) (= #b1 U1_RS3_qk_ROB_done)) U1_RS3_qk_update U1_RS_qk))
				(U2_LSQ_vj (ite (and (= #b1 U1_LSQ3_busy) (not (= #b000000 U1_LSQ3_qj)) (= #b1 U1_LSQ3_qj_ROB_done)) U1_LSQ3_vj_update U1_LSQ_vj))
				(U2_LSQ_vk (ite (and (= #b1 U1_LSQ3_busy) (not (= #b000000 U1_LSQ3_qk)) (= #b1 U1_LSQ3_qk_ROB_done)) U1_LSQ3_vk_update U1_LSQ_vk))
				(U2_LSQ_qj (ite (and (= #b1 U1_LSQ3_busy) (not (= #b000000 U1_LSQ3_qj)) (= #b1 U1_LSQ3_qj_ROB_done)) U1_LSQ3_qj_update U1_LSQ_qj))
				(U2_LSQ_qk (ite (and (= #b1 U1_LSQ3_busy) (not (= #b000000 U1_LSQ3_qk)) (= #b1 U1_LSQ3_qk_ROB_done)) U1_LSQ3_qk_update U1_LSQ_qk))
			)

        ;-- Creating RS4's and LSQ4's potential updated state, updating if required
		(let
			(
				(U1_RS4_vj_update (store U2_RS_vj (_ bv4 3) U1_RS4_qj_ROB_result))	
				(U1_RS4_vk_update (store U2_RS_vk (_ bv4 3) U1_RS4_qk_ROB_result))	
				(U1_RS4_qj_update (store U2_RS_qj (_ bv4 3) (_ bv0 6)))	
				(U1_RS4_qk_update (store U2_RS_qk (_ bv4 3) (_ bv0 6)))	
				(U1_LSQ4_vj_update (store U2_LSQ_vj (_ bv4 4) U1_LSQ4_qj_ROB_result))	
				(U1_LSQ4_vk_update (store U2_LSQ_vk (_ bv4 4) U1_LSQ4_qk_ROB_result))	
				(U1_LSQ4_qj_update (store U2_LSQ_qj (_ bv4 4) (_ bv0 6)))	
				(U1_LSQ4_qk_update (store U2_LSQ_qk (_ bv4 4) (_ bv0 6)))	
			)
		(let
			(
				(U2_RS_vj (ite (and (= #b1 U1_RS4_busy) (not (= #b000000 U1_RS4_qj)) (= #b1 U1_RS4_qj_ROB_done)) U1_RS4_vj_update U1_RS_vj))
				(U2_RS_vk (ite (and (= #b1 U1_RS4_busy) (not (= #b000000 U1_RS4_qk)) (= #b1 U1_RS4_qk_ROB_done)) U1_RS4_vk_update U1_RS_vk))
				(U2_RS_qj (ite (and (= #b1 U1_RS4_busy) (not (= #b000000 U1_RS4_qj)) (= #b1 U1_RS4_qj_ROB_done)) U1_RS4_qj_update U1_RS_qj))
				(U2_RS_qk (ite (and (= #b1 U1_RS4_busy) (not (= #b000000 U1_RS4_qk)) (= #b1 U1_RS4_qk_ROB_done)) U1_RS4_qk_update U1_RS_qk))
				(U2_LSQ_vj (ite (and (= #b1 U1_LSQ4_busy) (not (= #b000000 U1_LSQ4_qj)) (= #b1 U1_LSQ4_qj_ROB_done)) U1_LSQ4_vj_update U1_LSQ_vj))
				(U2_LSQ_vk (ite (and (= #b1 U1_LSQ4_busy) (not (= #b000000 U1_LSQ4_qk)) (= #b1 U1_LSQ4_qk_ROB_done)) U1_LSQ4_vk_update U1_LSQ_vk))
				(U2_LSQ_qj (ite (and (= #b1 U1_LSQ4_busy) (not (= #b000000 U1_LSQ4_qj)) (= #b1 U1_LSQ4_qj_ROB_done)) U1_LSQ4_qj_update U1_LSQ_qj))
				(U2_LSQ_qk (ite (and (= #b1 U1_LSQ4_busy) (not (= #b000000 U1_LSQ4_qk)) (= #b1 U1_LSQ4_qk_ROB_done)) U1_LSQ4_qk_update U1_LSQ_qk))
			)
        ;-- Creating RS5's and LSQ5's potential updated state, updating if required
		(let
			(
				(U1_RS5_vj_update (store U2_RS_vj (_ bv5 3) U1_RS5_qj_ROB_result))	
				(U1_RS5_vk_update (store U2_RS_vk (_ bv5 3) U1_RS5_qk_ROB_result))	
				(U1_RS5_qj_update (store U2_RS_qj (_ bv5 3) (_ bv0 6)))	
				(U1_RS5_qk_update (store U2_RS_qk (_ bv5 3) (_ bv0 6)))	
				(U1_LSQ5_vj_update (store U2_LSQ_vj (_ bv5 4) U1_LSQ5_qj_ROB_result))	
				(U1_LSQ5_vk_update (store U2_LSQ_vk (_ bv5 4) U1_LSQ5_qk_ROB_result))	
				(U1_LSQ5_qj_update (store U2_LSQ_qj (_ bv5 4) (_ bv0 6)))	
				(U1_LSQ5_qk_update (store U2_LSQ_qk (_ bv5 4) (_ bv0 6)))	
			)
		(let
			(
				(U2_RS_vj (ite (and (= #b1 U1_RS5_busy) (not (= #b000000 U1_RS5_qj)) (= #b1 U1_RS5_qj_ROB_done)) U1_RS5_vj_update U1_RS_vj))
				(U2_RS_vk (ite (and (= #b1 U1_RS5_busy) (not (= #b000000 U1_RS5_qk)) (= #b1 U1_RS5_qk_ROB_done)) U1_RS5_vk_update U1_RS_vk))
				(U2_RS_qj (ite (and (= #b1 U1_RS5_busy) (not (= #b000000 U1_RS5_qj)) (= #b1 U1_RS5_qj_ROB_done)) U1_RS5_qj_update U1_RS_qj))
				(U2_RS_qk (ite (and (= #b1 U1_RS5_busy) (not (= #b000000 U1_RS5_qk)) (= #b1 U1_RS5_qk_ROB_done)) U1_RS5_qk_update U1_RS_qk))
				(U2_LSQ_vj (ite (and (= #b1 U1_LSQ5_busy) (not (= #b000000 U1_LSQ5_qj)) (= #b1 U1_LSQ5_qj_ROB_done)) U1_LSQ5_vj_update U1_LSQ_vj))
				(U2_LSQ_vk (ite (and (= #b1 U1_LSQ5_busy) (not (= #b000000 U1_LSQ5_qk)) (= #b1 U1_LSQ5_qk_ROB_done)) U1_LSQ5_vk_update U1_LSQ_vk))
				(U2_LSQ_qj (ite (and (= #b1 U1_LSQ5_busy) (not (= #b000000 U1_LSQ5_qj)) (= #b1 U1_LSQ5_qj_ROB_done)) U1_LSQ5_qj_update U1_LSQ_qj))
				(U2_LSQ_qk (ite (and (= #b1 U1_LSQ5_busy) (not (= #b000000 U1_LSQ5_qk)) (= #b1 U1_LSQ5_qk_ROB_done)) U1_LSQ5_qk_update U1_LSQ_qk))
			)
		;-- Creating RS6's and LSQ6's potential updated state, updating if required
		(let
			(
				(U1_RS6_vj_update (store U2_RS_vj (_ bv6 3) U1_RS6_qj_ROB_result))	
				(U1_RS6_vk_update (store U2_RS_vk (_ bv6 3) U1_RS6_qk_ROB_result))	
				(U1_RS6_qj_update (store U2_RS_qj (_ bv6 3) (_ bv0 6)))	
				(U1_RS6_qk_update (store U2_RS_qk (_ bv6 3) (_ bv0 6)))	
				(U1_LSQ6_vj_update (store U2_LSQ_vj (_ bv6 4) U1_LSQ6_qj_ROB_result))	
				(U1_LSQ6_vk_update (store U2_LSQ_vk (_ bv6 4) U1_LSQ6_qk_ROB_result))	
				(U1_LSQ6_qj_update (store U2_LSQ_qj (_ bv6 4) (_ bv0 6)))	
				(U1_LSQ6_qk_update (store U2_LSQ_qk (_ bv6 4) (_ bv0 6)))	
			)
		(let
			(
				(U2_RS_vj (ite (and (= #b1 U1_RS6_busy) (not (= #b000000 U1_RS6_qj)) (= #b1 U1_RS6_qj_ROB_done)) U1_RS6_vj_update U1_RS_vj))
				(U2_RS_vk (ite (and (= #b1 U1_RS6_busy) (not (= #b000000 U1_RS6_qk)) (= #b1 U1_RS6_qk_ROB_done)) U1_RS6_vk_update U1_RS_vk))
				(U2_RS_qj (ite (and (= #b1 U1_RS6_busy) (not (= #b000000 U1_RS6_qj)) (= #b1 U1_RS6_qj_ROB_done)) U1_RS6_qj_update U1_RS_qj))
				(U2_RS_qk (ite (and (= #b1 U1_RS6_busy) (not (= #b000000 U1_RS6_qk)) (= #b1 U1_RS6_qk_ROB_done)) U1_RS6_qk_update U1_RS_qk))
				(U2_LSQ_vj (ite (and (= #b1 U1_LSQ6_busy) (not (= #b000000 U1_LSQ6_qj)) (= #b1 U1_LSQ6_qj_ROB_done)) U1_LSQ6_vj_update U1_LSQ_vj))
				(U2_LSQ_vk (ite (and (= #b1 U1_LSQ6_busy) (not (= #b000000 U1_LSQ6_qk)) (= #b1 U1_LSQ6_qk_ROB_done)) U1_LSQ6_vk_update U1_LSQ_vk))
				(U2_LSQ_qj (ite (and (= #b1 U1_LSQ6_busy) (not (= #b000000 U1_LSQ6_qj)) (= #b1 U1_LSQ6_qj_ROB_done)) U1_LSQ6_qj_update U1_LSQ_qj))
				(U2_LSQ_qk (ite (and (= #b1 U1_LSQ6_busy) (not (= #b000000 U1_LSQ6_qk)) (= #b1 U1_LSQ6_qk_ROB_done)) U1_LSQ6_qk_update U1_LSQ_qk))
			)
		;-- Creating RS7's and LSQ7's potential updated state, updating if required
		(let
			(
				(U1_RS7_vj_update (store U2_RS_vj (_ bv7 3) U1_RS7_qj_ROB_result))	
				(U1_RS7_vk_update (store U2_RS_vk (_ bv7 3) U1_RS7_qk_ROB_result))	
				(U1_RS7_qj_update (store U2_RS_qj (_ bv7 3) (_ bv0 6)))	
				(U1_RS7_qk_update (store U2_RS_qk (_ bv7 3) (_ bv0 6)))	
				(U1_LSQ7_vj_update (store U2_LSQ_vj (_ bv7 4) U1_LSQ7_qj_ROB_result))	
				(U1_LSQ7_vk_update (store U2_LSQ_vk (_ bv7 4) U1_LSQ7_qk_ROB_result))	
				(U1_LSQ7_qj_update (store U2_LSQ_qj (_ bv7 4) (_ bv0 6)))	
				(U1_LSQ7_qk_update (store U2_LSQ_qk (_ bv7 4) (_ bv0 6)))	
			)
		(let
			(
				(U2_RS_vj (ite (and (= #b1 U1_RS7_busy) (not (= #b000000 U1_RS7_qj)) (= #b1 U1_RS7_qj_ROB_done)) U1_RS7_vj_update U1_RS_vj))
				(U2_RS_vk (ite (and (= #b1 U1_RS7_busy) (not (= #b000000 U1_RS7_qk)) (= #b1 U1_RS7_qk_ROB_done)) U1_RS7_vk_update U1_RS_vk))
				(U2_RS_qj (ite (and (= #b1 U1_RS7_busy) (not (= #b000000 U1_RS7_qj)) (= #b1 U1_RS7_qj_ROB_done)) U1_RS7_qj_update U1_RS_qj))
				(U2_RS_qk (ite (and (= #b1 U1_RS7_busy) (not (= #b000000 U1_RS7_qk)) (= #b1 U1_RS7_qk_ROB_done)) U1_RS7_qk_update U1_RS_qk))
				(U2_LSQ_vj (ite (and (= #b1 U1_LSQ7_busy) (not (= #b000000 U1_LSQ7_qj)) (= #b1 U1_LSQ7_qj_ROB_done)) U1_LSQ7_vj_update U1_LSQ_vj))
				(U2_LSQ_vk (ite (and (= #b1 U1_LSQ7_busy) (not (= #b000000 U1_LSQ7_qk)) (= #b1 U1_LSQ7_qk_ROB_done)) U1_LSQ7_vk_update U1_LSQ_vk))
				(U2_LSQ_qj (ite (and (= #b1 U1_LSQ7_busy) (not (= #b000000 U1_LSQ7_qj)) (= #b1 U1_LSQ7_qj_ROB_done)) U1_LSQ7_qj_update U1_LSQ_qj))
				(U2_LSQ_qk (ite (and (= #b1 U1_LSQ7_busy) (not (= #b000000 U1_LSQ7_qk)) (= #b1 U1_LSQ7_qk_ROB_done)) U1_LSQ7_qk_update U1_LSQ_qk))
			)

		;-- Creating  LSQ8's potential updated state, updating if required
		(let
			(	
				(U1_LSQ8_vj_update (store U2_LSQ_vj (_ bv8 4) U1_LSQ8_qj_ROB_result))	
				(U1_LSQ8_vk_update (store U2_LSQ_vk (_ bv8 4) U1_LSQ8_qk_ROB_result))	
				(U1_LSQ8_qj_update (store U2_LSQ_qj (_ bv8 4) (_ bv0 6)))	
				(U1_LSQ8_qk_update (store U2_LSQ_qk (_ bv8 4) (_ bv0 6)))	
			)
		(let
			(
				
				(U2_LSQ_vj (ite (and (= #b1 U1_LSQ8_busy) (not (= #b000000 U1_LSQ8_qj)) (= #b1 U1_LSQ8_qj_ROB_done)) U1_LSQ8_vj_update U1_LSQ_vj))
				(U2_LSQ_vk (ite (and (= #b1 U1_LSQ8_busy) (not (= #b000000 U1_LSQ8_qk)) (= #b1 U1_LSQ8_qk_ROB_done)) U1_LSQ8_vk_update U1_LSQ_vk))
				(U2_LSQ_qj (ite (and (= #b1 U1_LSQ8_busy) (not (= #b000000 U1_LSQ8_qj)) (= #b1 U1_LSQ8_qj_ROB_done)) U1_LSQ8_qj_update U1_LSQ_qj))
				(U2_LSQ_qk (ite (and (= #b1 U1_LSQ8_busy) (not (= #b000000 U1_LSQ8_qk)) (= #b1 U1_LSQ8_qk_ROB_done)) U1_LSQ8_qk_update U1_LSQ_qk))
			)


					;-- Creating  LSQ9's potential updated state, updating if required
		(let
			(
	
				(U1_LSQ9_vj_update (store U2_LSQ_vj (_ bv9 4) U1_LSQ9_qj_ROB_result))	
				(U1_LSQ9_vk_update (store U2_LSQ_vk (_ bv9 4) U1_LSQ9_qk_ROB_result))	
				(U1_LSQ9_qj_update (store U2_LSQ_qj (_ bv9 4) (_ bv0 6)))	
				(U1_LSQ9_qk_update (store U2_LSQ_qk (_ bv9 4) (_ bv0 6)))	
			)
		(let
			(
				(U2_LSQ_vj (ite (and (= #b1 U1_LSQ9_busy) (not (= #b000000 U1_LSQ9_qj)) (= #b1 U1_LSQ9_qj_ROB_done)) U1_LSQ9_vj_update U1_LSQ_vj))
				(U2_LSQ_vk (ite (and (= #b1 U1_LSQ9_busy) (not (= #b000000 U1_LSQ9_qk)) (= #b1 U1_LSQ9_qk_ROB_done)) U1_LSQ9_vk_update U1_LSQ_vk))
				(U2_LSQ_qj (ite (and (= #b1 U1_LSQ9_busy) (not (= #b000000 U1_LSQ9_qj)) (= #b1 U1_LSQ9_qj_ROB_done)) U1_LSQ9_qj_update U1_LSQ_qj))
				(U2_LSQ_qk (ite (and (= #b1 U1_LSQ9_busy) (not (= #b000000 U1_LSQ9_qk)) (= #b1 U1_LSQ9_qk_ROB_done)) U1_LSQ9_qk_update U1_LSQ_qk))
			)

		;-- Creating LSQ10's potential updated state, updating if required
		(let
			(	
				(U1_LSQ10_vj_update (store U2_LSQ_vj (_ bv10 4) U1_LSQ10_qj_ROB_result))	
				(U1_LSQ10_vk_update (store U2_LSQ_vk (_ bv10 4) U1_LSQ10_qk_ROB_result))	
				(U1_LSQ10_qj_update (store U2_LSQ_qj (_ bv10 4) (_ bv0 6)))	
				(U1_LSQ10_qk_update (store U2_LSQ_qk (_ bv10 4) (_ bv0 6)))	
			)
		(let
			(
				
				(U2_LSQ_vj (ite (and (= #b1 U1_LSQ10_busy) (not (= #b000000 U1_LSQ10_qj)) (= #b1 U1_LSQ10_qj_ROB_done)) U1_LSQ10_vj_update U1_LSQ_vj))
				(U2_LSQ_vk (ite (and (= #b1 U1_LSQ10_busy) (not (= #b000000 U1_LSQ10_qk)) (= #b1 U1_LSQ10_qk_ROB_done)) U1_LSQ10_vk_update U1_LSQ_vk))
				(U2_LSQ_qj (ite (and (= #b1 U1_LSQ10_busy) (not (= #b000000 U1_LSQ10_qj)) (= #b1 U1_LSQ10_qj_ROB_done)) U1_LSQ10_qj_update U1_LSQ_qj))
				(U2_LSQ_qk (ite (and (= #b1 U1_LSQ10_busy) (not (= #b000000 U1_LSQ10_qk)) (= #b1 U1_LSQ10_qk_ROB_done)) U1_LSQ10_qk_update U1_LSQ_qk))
			)

		;-- Creating LSQ11's potential updated state, updating if required
		(let
			(	
				(U1_LSQ11_vj_update (store U2_LSQ_vj (_ bv11 4) U1_LSQ11_qj_ROB_result))	
				(U1_LSQ11_vk_update (store U2_LSQ_vk (_ bv11 4) U1_LSQ11_qk_ROB_result))	
				(U1_LSQ11_qj_update (store U2_LSQ_qj (_ bv11 4) (_ bv0 6)))	
				(U1_LSQ11_qk_update (store U2_LSQ_qk (_ bv11 4) (_ bv0 6)))	
			)
		(let
			(
				(U2_LSQ_vj (ite (and (= #b1 U1_LSQ11_busy) (not (= #b000000 U1_LSQ11_qj)) (= #b1 U1_LSQ11_qj_ROB_done)) U1_LSQ11_vj_update U1_LSQ_vj))
				(U2_LSQ_vk (ite (and (= #b1 U1_LSQ11_busy) (not (= #b000000 U1_LSQ11_qk)) (= #b1 U1_LSQ11_qk_ROB_done)) U1_LSQ11_vk_update U1_LSQ_vk))
				(U2_LSQ_qj (ite (and (= #b1 U1_LSQ11_busy) (not (= #b000000 U1_LSQ11_qj)) (= #b1 U1_LSQ11_qj_ROB_done)) U1_LSQ11_qj_update U1_LSQ_qj))
				(U2_LSQ_qk (ite (and (= #b1 U1_LSQ11_busy) (not (= #b000000 U1_LSQ11_qk)) (= #b1 U1_LSQ11_qk_ROB_done)) U1_LSQ11_qk_update U1_LSQ_qk))
			)

		;-- Creating RS12's and LSQ12's potential updated state, updating if required
		(let
			(	
				(U1_LSQ12_vj_update (store U2_LSQ_vj (_ bv12 4) U1_LSQ12_qj_ROB_result))	
				(U1_LSQ12_vk_update (store U2_LSQ_vk (_ bv12 4) U1_LSQ12_qk_ROB_result))	
				(U1_LSQ12_qj_update (store U2_LSQ_qj (_ bv12 4) (_ bv0 6)))	
				(U1_LSQ12_qk_update (store U2_LSQ_qk (_ bv12 4) (_ bv0 6)))	
			)
		(let
			(
				(U2_LSQ_vj (ite (and (= #b1 U1_LSQ12_busy) (not (= #b000000 U1_LSQ12_qj)) (= #b1 U1_LSQ12_qj_ROB_done)) U1_LSQ12_vj_update U1_LSQ_vj))
				(U2_LSQ_vk (ite (and (= #b1 U1_LSQ12_busy) (not (= #b000000 U1_LSQ12_qk)) (= #b1 U1_LSQ12_qk_ROB_done)) U1_LSQ12_vk_update U1_LSQ_vk))
				(U2_LSQ_qj (ite (and (= #b1 U1_LSQ12_busy) (not (= #b000000 U1_LSQ12_qj)) (= #b1 U1_LSQ12_qj_ROB_done)) U1_LSQ12_qj_update U1_LSQ_qj))
				(U2_LSQ_qk (ite (and (= #b1 U1_LSQ12_busy) (not (= #b000000 U1_LSQ12_qk)) (= #b1 U1_LSQ12_qk_ROB_done)) U1_LSQ12_qk_update U1_LSQ_qk))
			)

		;-- Creating  LSQ13's potential updated state, updating if required
		(let
			(	
				(U1_LSQ13_vj_update (store U2_LSQ_vj (_ bv13 4) U1_LSQ13_qj_ROB_result))	
				(U1_LSQ13_vk_update (store U2_LSQ_vk (_ bv13 4) U1_LSQ13_qk_ROB_result))	
				(U1_LSQ13_qj_update (store U2_LSQ_qj (_ bv13 4) (_ bv0 6)))	
				(U1_LSQ13_qk_update (store U2_LSQ_qk (_ bv13 4) (_ bv0 6)))	
			)
		(let
			(
				(U2_LSQ_vj (ite (and (= #b1 U1_LSQ13_busy) (not (= #b000000 U1_LSQ13_qj)) (= #b1 U1_LSQ13_qj_ROB_done)) U1_LSQ13_vj_update U1_LSQ_vj))
				(U2_LSQ_vk (ite (and (= #b1 U1_LSQ13_busy) (not (= #b000000 U1_LSQ13_qk)) (= #b1 U1_LSQ13_qk_ROB_done)) U1_LSQ13_vk_update U1_LSQ_vk))
				(U2_LSQ_qj (ite (and (= #b1 U1_LSQ13_busy) (not (= #b000000 U1_LSQ13_qj)) (= #b1 U1_LSQ13_qj_ROB_done)) U1_LSQ13_qj_update U1_LSQ_qj))
				(U2_LSQ_qk (ite (and (= #b1 U1_LSQ13_busy) (not (= #b000000 U1_LSQ13_qk)) (= #b1 U1_LSQ13_qk_ROB_done)) U1_LSQ13_qk_update U1_LSQ_qk))
			)

		;-- Creating  LSQ14's potential updated state, updating if required
		(let
			(	
				(U1_LSQ14_vj_update (store U2_LSQ_vj (_ bv14 4) U1_LSQ14_qj_ROB_result))	
				(U1_LSQ14_vk_update (store U2_LSQ_vk (_ bv14 4) U1_LSQ14_qk_ROB_result))	
				(U1_LSQ14_qj_update (store U2_LSQ_qj (_ bv14 4) (_ bv0 6)))	
				(U1_LSQ14_qk_update (store U2_LSQ_qk (_ bv14 4) (_ bv0 6)))	
			)
		(let
            (
            	(U2_LSQ_vj (ite (and (= #b1 U1_LSQ14_busy) (not (= #b000000 U1_LSQ14_qj)) (= #b1 U1_LSQ14_qj_ROB_done)) U1_LSQ14_vj_update U1_LSQ_vj))
				(U2_LSQ_vk (ite (and (= #b1 U1_LSQ14_busy) (not (= #b000000 U1_LSQ14_qk)) (= #b1 U1_LSQ14_qk_ROB_done)) U1_LSQ14_vk_update U1_LSQ_vk))
				(U2_LSQ_qj (ite (and (= #b1 U1_LSQ14_busy) (not (= #b000000 U1_LSQ14_qj)) (= #b1 U1_LSQ14_qj_ROB_done)) U1_LSQ14_qj_update U1_LSQ_qj))
				(U2_LSQ_qk (ite (and (= #b1 U1_LSQ14_busy) (not (= #b000000 U1_LSQ14_qk)) (= #b1 U1_LSQ14_qk_ROB_done)) U1_LSQ14_qk_update U1_LSQ_qk))
			)

		;-- Creating  LSQ15's potential updated state, updating if required
		(let
			(	
				(U1_LSQ15_vj_update (store U2_LSQ_vj (_ bv15 4) U1_LSQ15_qj_ROB_result))	
				(U1_LSQ15_vk_update (store U2_LSQ_vk (_ bv15 4) U1_LSQ15_qk_ROB_result))	
				(U1_LSQ15_qj_update (store U2_LSQ_qj (_ bv15 4) (_ bv0 6)))	
				(U1_LSQ15_qk_update (store U2_LSQ_qk (_ bv15 4) (_ bv0 6)))	
			)
		(let
			(
				(U2_LSQ_vj (ite (and (= #b1 U1_LSQ15_busy) (not (= #b000000 U1_LSQ15_qj)) (= #b1 U1_LSQ15_qj_ROB_done)) U1_LSQ15_vj_update U1_LSQ_vj))
				(U2_LSQ_vk (ite (and (= #b1 U1_LSQ15_busy) (not (= #b000000 U1_LSQ15_qk)) (= #b1 U1_LSQ15_qk_ROB_done)) U1_LSQ15_vk_update U1_LSQ_vk))
				(U2_LSQ_qj (ite (and (= #b1 U1_LSQ15_busy) (not (= #b000000 U1_LSQ15_qj)) (= #b1 U1_LSQ15_qj_ROB_done)) U1_LSQ15_qj_update U1_LSQ_qj))
				(U2_LSQ_qk (ite (and (= #b1 U1_LSQ15_busy) (not (= #b000000 U1_LSQ15_qk)) (= #b1 U1_LSQ15_qk_ROB_done)) U1_LSQ15_qk_update U1_LSQ_qk))
			)


		;-- Getting busy and Tag values from all the RS and LSQ entries
		(let
			(
				(U2_RS0_busy (select U1_RS_busy (_ bv0 3)))
				(U2_RS0_qj (select U2_RS_qj (_ bv0 3)))
				(U2_RS0_qk (select U2_RS_qk (_ bv0 3)))
				(U2_RS1_busy (select U1_RS_busy (_ bv1 3)))
				(U2_RS1_qj (select U2_RS_qj (_ bv1 3)))
				(U2_RS1_qk (select U2_RS_qk (_ bv1 3)))
				(U2_RS2_busy (select U1_RS_busy (_ bv2 3)))
				(U2_RS2_qj (select U2_RS_qj (_ bv2 3)))
				(U2_RS2_qk (select U2_RS_qk (_ bv2 3)))
				(U2_RS3_busy (select U1_RS_busy (_ bv3 3)))
				(U2_RS3_qj (select U2_RS_qj (_ bv3 3)))
				(U2_RS3_qk (select U2_RS_qk (_ bv3 3)))		
				(U2_RS4_busy (select U1_RS_busy (_ bv4 3)))
				(U2_RS4_qj (select U2_RS_qj (_ bv4 3)))
				(U2_RS4_qk (select U2_RS_qk (_ bv4 3)))
				(U2_RS5_busy (select U1_RS_busy (_ bv5 3)))
				(U2_RS5_qj (select U2_RS_qj (_ bv5 3)))
				(U2_RS5_qk (select U2_RS_qk (_ bv5 3)))
				(U2_RS6_busy (select U1_RS_busy (_ bv6 3)))
				(U2_RS6_qj (select U2_RS_qj (_ bv6 3)))
				(U2_RS6_qk (select U2_RS_qk (_ bv6 3)))
				(U2_RS7_busy (select U1_RS_busy (_ bv7 3)))
				(U2_RS7_qj (select U2_RS_qj (_ bv7 3)))
				(U2_RS7_qk (select U2_RS_qk (_ bv7 3)))

                (U2_LSQ0_busy (select U1_LSQ_busy (_ bv0 4)))
				(U2_LSQ0_qj (select U2_LSQ_qj (_ bv0 4)))
				(U2_LSQ0_qk (select U2_LSQ_qk (_ bv0 4)))
				(U2_LSQ1_busy (select U1_LSQ_busy (_ bv1 4)))
				(U2_LSQ1_qj (select U2_LSQ_qj (_ bv1 4)))
				(U2_LSQ1_qk (select U2_LSQ_qk (_ bv1 4)))
				(U2_LSQ2_busy (select U1_LSQ_busy (_ bv2 4)))
				(U2_LSQ2_qj (select U2_LSQ_qj (_ bv2 4)))
				(U2_LSQ2_qk (select U2_LSQ_qk (_ bv2 4)))
				(U2_LSQ3_busy (select U1_LSQ_busy (_ bv3 4)))
				(U2_LSQ3_qj (select U2_LSQ_qj (_ bv3 4)))
				(U2_LSQ3_qk (select U2_LSQ_qk (_ bv3 4)))
				(U2_LSQ4_busy (select U1_LSQ_busy (_ bv4 4)))
				(U2_LSQ4_qj (select U2_LSQ_qj (_ bv4 4)))
				(U2_LSQ4_qk (select U2_LSQ_qk (_ bv4 4)))
				(U2_LSQ5_busy (select U1_LSQ_busy (_ bv5 4)))
				(U2_LSQ5_qj (select U2_LSQ_qj (_ bv5 4)))
				(U2_LSQ5_qk (select U2_LSQ_qk (_ bv5 4)))
				(U2_LSQ6_busy (select U1_LSQ_busy (_ bv6 4)))
				(U2_LSQ6_qj (select U2_LSQ_qj (_ bv6 4)))
				(U2_LSQ6_qk (select U2_LSQ_qk (_ bv6 4)))
				(U2_LSQ7_busy (select U1_LSQ_busy (_ bv7 4)))
				(U2_LSQ7_qj (select U2_LSQ_qj (_ bv7 4)))
				(U2_LSQ7_qk (select U2_LSQ_qk (_ bv7 4)))
				(U2_LSQ8_busy (select U1_LSQ_busy (_ bv8 4)))
				(U2_LSQ8_qj (select U2_LSQ_qj (_ bv8 4)))
				(U2_LSQ8_qk (select U2_LSQ_qk (_ bv8 4)))
				(U2_LSQ9_busy (select U1_LSQ_busy (_ bv9 4)))
				(U2_LSQ9_qj (select U2_LSQ_qj (_ bv9 4)))
				(U2_LSQ9_qk (select U2_LSQ_qk (_ bv9 4)))
				(U2_LSQ10_busy (select U1_LSQ_busy (_ bv10 4)))
				(U2_LSQ10_qj (select U2_LSQ_qj (_ bv10 4)))
				(U2_LSQ10_qk (select U2_LSQ_qk (_ bv10 4)))
				(U2_LSQ11_busy (select U1_LSQ_busy (_ bv11 4)))
				(U2_LSQ11_qj (select U2_LSQ_qj (_ bv11 4)))
				(U2_LSQ11_qk (select U2_LSQ_qk (_ bv11 4)))
				(U2_LSQ12_busy (select U1_LSQ_busy (_ bv12 4)))
				(U2_LSQ12_qj (select U2_LSQ_qj (_ bv12 4)))
				(U2_LSQ12_qk (select U2_LSQ_qk (_ bv12 4)))
				(U2_LSQ13_busy (select U1_LSQ_busy (_ bv13 4)))
				(U2_LSQ13_qj (select U2_LSQ_qj (_ bv13 4)))
				(U2_LSQ13_qk (select U2_LSQ_qk (_ bv13 4)))
				(U2_LSQ14_busy (select U1_LSQ_busy (_ bv14 4)))
				(U2_LSQ14_qj (select U2_LSQ_qj (_ bv14 4)))
				(U2_LSQ14_qk (select U2_LSQ_qk (_ bv14 4)))
				(U2_LSQ15_busy (select U1_LSQ_busy (_ bv15 4)))
				(U2_LSQ15_qj (select U2_LSQ_qj (_ bv15 4)))
				(U2_LSQ15_qk (select U2_LSQ_qk (_ bv15 4)))
			)
		;-- Generating new dispatch bits (1 if tags == 0)
		(let
			(
				(U2_RS0_dis (ite (and (= #b1 U2_RS0_busy) (= #b000000 U2_RS0_qj) (= #b000000 U2_RS0_qk)) (_ bv1 1) (_ bv0 1)))
				(U2_RS1_dis (ite (and (= #b1 U2_RS1_busy) (= #b000000 U2_RS1_qj) (= #b000000 U2_RS1_qk)) (_ bv1 1) (_ bv0 1)))
				(U2_RS2_dis (ite (and (= #b1 U2_RS2_busy) (= #b000000 U2_RS2_qj) (= #b000000 U2_RS2_qk)) (_ bv1 1) (_ bv0 1)))
				(U2_RS3_dis (ite (and (= #b1 U2_RS3_busy) (= #b000000 U2_RS3_qj) (= #b000000 U2_RS3_qk)) (_ bv1 1) (_ bv0 1)))
				(U2_RS4_dis (ite (and (= #b1 U2_RS4_busy) (= #b000000 U2_RS4_qj) (= #b000000 U2_RS4_qk)) (_ bv1 1) (_ bv0 1)))
				(U2_RS5_dis (ite (and (= #b1 U2_RS5_busy) (= #b000000 U2_RS5_qj) (= #b000000 U2_RS5_qk)) (_ bv1 1) (_ bv0 1)))	
				(U2_RS6_dis (ite (and (= #b1 U2_RS6_busy) (= #b000000 U2_RS6_qj) (= #b000000 U2_RS6_qk)) (_ bv1 1) (_ bv0 1)))	
				(U2_RS7_dis (ite (and (= #b1 U2_RS7_busy) (= #b000000 U2_RS7_qj) (= #b000000 U2_RS7_qk)) (_ bv1 1) (_ bv0 1)))

				(U2_LSQ0_dis (ite (and (= #b1 U2_LSQ0_busy) (= #b000000 U2_LSQ0_qj) (= #b000000 U2_LSQ0_qk)) (_ bv1 1) (_ bv0 1)))
				(U2_LSQ1_dis (ite (and (= #b1 U2_LSQ1_busy) (= #b000000 U2_LSQ1_qj) (= #b000000 U2_LSQ1_qk)) (_ bv1 1) (_ bv0 1)))
				(U2_LSQ2_dis (ite (and (= #b1 U2_LSQ2_busy) (= #b000000 U2_LSQ2_qj) (= #b000000 U2_LSQ2_qk)) (_ bv1 1) (_ bv0 1)))
				(U2_LSQ3_dis (ite (and (= #b1 U2_LSQ3_busy) (= #b000000 U2_LSQ3_qj) (= #b000000 U2_LSQ3_qk)) (_ bv1 1) (_ bv0 1)))
				(U2_LSQ4_dis (ite (and (= #b1 U2_LSQ4_busy) (= #b000000 U2_LSQ4_qj) (= #b000000 U2_LSQ4_qk)) (_ bv1 1) (_ bv0 1)))
				(U2_LSQ5_dis (ite (and (= #b1 U2_LSQ5_busy) (= #b000000 U2_LSQ5_qj) (= #b000000 U2_LSQ5_qk)) (_ bv1 1) (_ bv0 1)))
				(U2_LSQ6_dis (ite (and (= #b1 U2_LSQ6_busy) (= #b000000 U2_LSQ6_qj) (= #b000000 U2_LSQ6_qk)) (_ bv1 1) (_ bv0 1)))
				(U2_LSQ7_dis (ite (and (= #b1 U2_LSQ7_busy) (= #b000000 U2_LSQ7_qj) (= #b000000 U2_LSQ7_qk)) (_ bv1 1) (_ bv0 1)))
				(U2_LSQ8_dis (ite (and (= #b1 U2_LSQ8_busy) (= #b000000 U2_LSQ8_qj) (= #b000000 U2_LSQ8_qk)) (_ bv1 1) (_ bv0 1)))
				(U2_LSQ9_dis (ite (and (= #b1 U2_LSQ9_busy) (= #b000000 U2_LSQ9_qj) (= #b000000 U2_LSQ9_qk)) (_ bv1 1) (_ bv0 1)))
				(U2_LSQ10_dis (ite (and (= #b1 U2_LSQ10_busy) (= #b000000 U2_LSQ10_qj) (= #b000000 U2_LSQ10_qk)) (_ bv1 1) (_ bv0 1)))
				(U2_LSQ11_dis (ite (and (= #b1 U2_LSQ11_busy) (= #b000000 U2_LSQ11_qj) (= #b000000 U2_LSQ11_qk)) (_ bv1 1) (_ bv0 1)))
				(U2_LSQ12_dis (ite (and (= #b1 U2_LSQ12_busy) (= #b000000 U2_LSQ12_qj) (= #b000000 U2_LSQ12_qk)) (_ bv1 1) (_ bv0 1)))
				(U2_LSQ13_dis (ite (and (= #b1 U2_LSQ13_busy) (= #b000000 U2_LSQ13_qj) (= #b000000 U2_LSQ13_qk)) (_ bv1 1) (_ bv0 1)))
				(U2_LSQ14_dis (ite (and (= #b1 U2_LSQ14_busy) (= #b000000 U2_LSQ14_qj) (= #b000000 U2_LSQ14_qk)) (_ bv1 1) (_ bv0 1)))
				(U2_LSQ15_dis (ite (and (= #b1 U2_LSQ15_busy) (= #b000000 U2_LSQ15_qj) (= #b000000 U2_LSQ15_qk)) (_ bv1 1) (_ bv0 1)))
			)	

		;-- Storing them back into the entries
		(let
			(
				(U2_RS_dis (store U1_RS_dis (_ bv0 3) U2_RS0_dis))
				(U2_LSQ_dis (store U1_LSQ_dis (_ bv0 4) U2_LSQ0_dis))
			)
		(let
			(
				(U2_RS_dis (store U2_RS_dis (_ bv1 3) U2_RS1_dis))
				(U2_LSQ_dis (store U2_LSQ_dis (_ bv1 4) U2_LSQ1_dis))
			)
		(let
			(
				(U2_RS_dis (store U2_RS_dis (_ bv2 3) U2_RS2_dis))
				(U2_LSQ_dis (store U2_LSQ_dis (_ bv2 4) U2_LSQ2_dis))
			)
		(let
			(
				(U2_RS_dis (store U2_RS_dis (_ bv3 3) U2_RS3_dis))
				(U2_LSQ_dis (store U2_LSQ_dis (_ bv3 4) U2_LSQ3_dis))
			)
		(let
			(
				(U2_RS_dis (store U2_RS_dis (_ bv4 3) U2_RS4_dis))
				(U2_LSQ_dis (store U2_LSQ_dis (_ bv4 4) U2_LSQ4_dis))
			)
		(let
			(
				(U2_RS_dis (store U2_RS_dis (_ bv5 3) U2_RS5_dis))
				(U2_LSQ_dis (store U2_LSQ_dis (_ bv5 4) U2_LSQ5_dis))
			)
		(let
			(
				(U2_RS_dis (store U2_RS_dis (_ bv6 3) U2_RS6_dis))
				(U2_LSQ_dis (store U2_LSQ_dis (_ bv6 4) U2_LSQ6_dis))
			)
		(let
			(
				(U2_RS_dis (store U2_RS_dis (_ bv7 3) U2_RS7_dis))
				(U2_LSQ_dis (store U2_LSQ_dis (_ bv7 4) U2_LSQ7_dis))
			)

		(let
			(
				(U2_LSQ_dis (store U2_LSQ_dis (_ bv8 4) U2_LSQ8_dis))
			)

		(let
			(
				
				(U2_LSQ_dis (store U2_LSQ_dis (_ bv9 4) U2_LSQ9_dis))
			)

		(let
			(
				
				(U2_LSQ_dis (store U2_LSQ_dis (_ bv10 4) U2_LSQ10_dis))
			)

		(let
			(
				
				(U2_LSQ_dis (store U2_LSQ_dis (_ bv11 4) U2_LSQ11_dis))
			)

        (let
			(
				
				(U2_LSQ_dis (store U2_LSQ_dis (_ bv12 4) U2_LSQ12_dis))
			)

        (let
			(
				(U2_LSQ_dis (store U2_LSQ_dis (_ bv13 4) U2_LSQ13_dis))
			)
			
        (let
			(
				(U2_LSQ_dis (store U2_LSQ_dis (_ bv14 4) U2_LSQ14_dis))
			)

		(let
			(
				(U2_LSQ_dis (store U2_LSQ_dis (_ bv15 4) U2_LSQ15_dis))
			)
		;-- Transistion to next state (U2)
		(let
			(
				(U2_RF (ite (= 0 0) U1_RF U1_RF))
				(U2_DM (ite (= 0 0) U1_DM U1_DM))
				
				(U2_CacheL1_Tag (ite (= 0 0) U1_CacheL1_Tag U1_CacheL1_Tag))
				(U2_CacheL1_Data (ite (= 0 0) U1_CacheL1_Data U1_CacheL1_Data))
				(U2_CacheL1_Valid (ite (= 0 0) U1_CacheL1_Valid U1_CacheL1_Valid))
				
				(U2_PC (ite (= 0 0) U1_PC U1_PC))
				
				(U2_IP (ite (= 0 0) U1_IP U1_IP))
				(U2_CP (ite (= 0 0) U1_CP U1_CP))
				
				(U2_ROB_busy (ite (= 0 0) U1_ROB_busy U1_ROB_busy))
				(U2_ROB_op (ite (= 0 0) U1_ROB_op U1_ROB_op))
				(U2_ROB_destination (ite (= 0 0) U1_ROB_destination U1_ROB_destination))
				(U2_ROB_result (ite (= 0 0) U1_ROB_result U1_ROB_result))
				(U2_ROB_exception (ite (= 0 0) U1_ROB_exception U1_ROB_exception))
				(U2_ROB_done (ite (= 0 0) U1_ROB_done U1_ROB_done))
				(U2_ROB_Maddress (ite (= 0 0) U1_ROB_Maddress U1_ROB_Maddress))
				
				(U2_RS_op (ite (= 0 0) U1_RS_op U1_RS_op))
				(U2_RS_ROB_dst (ite (= 0 0) U1_RS_ROB_dst U1_RS_ROB_dst))
				(U2_RS_vj (ite (= 0 0) U2_RS_vj U2_RS_vj))
				(U2_RS_vk (ite (= 0 0) U2_RS_vk U2_RS_vk))
				(U2_RS_qj (ite (= 0 0) U2_RS_qj U2_RS_qj))
				(U2_RS_qk (ite (= 0 0) U2_RS_qk U2_RS_qk))
				(U2_RS_imm (ite (= 0 0) U1_RS_imm U1_RS_imm))
				(U2_RS_dis (ite (= 0 0) U2_RS_dis U2_RS_dis))
				(U2_RS_busy (ite (= 0 0) U1_RS_busy U1_RS_busy))
				
				(U2_LSQ_op (ite (= 0 0) U1_LSQ_op U1_LSQ_op))
				(U2_LSQ_ROB_dst (ite (= 0 0) U1_LSQ_ROB_dst U1_LSQ_ROB_dst))
				(U2_LSQ_vj (ite (= 0 0) U2_LSQ_vj U2_LSQ_vj))
				(U2_LSQ_vk (ite (= 0 0) U2_LSQ_vk U2_LSQ_vk))
				(U2_LSQ_qj (ite (= 0 0) U2_LSQ_qj U2_LSQ_qj))
				(U2_LSQ_qk (ite (= 0 0) U2_LSQ_qk U2_LSQ_qk))
				(U2_LSQ_imm (ite (= 0 0) U1_LSQ_imm U1_LSQ_imm))
				(U2_LSQ_dis (ite (= 0 0) U2_LSQ_dis U2_LSQ_dis))
				(U2_LSQ_busy (ite (= 0 0) U1_LSQ_busy U1_LSQ_busy))	
			)			
;---------------------------Dispatch, Broadcast and Update------------------
		;-- Get all the dispatch bits from RS
		(let
			(
				(U2_RS0_dis (select U2_RS_dis (_ bv0 3)))
				(U2_RS1_dis (select U2_RS_dis (_ bv1 3)))
				(U2_RS2_dis (select U2_RS_dis (_ bv2 3)))
				(U2_RS3_dis (select U2_RS_dis (_ bv3 3)))
				(U2_RS4_dis (select U2_RS_dis (_ bv4 3)))
				(U2_RS5_dis (select U2_RS_dis (_ bv5 3)))
				(U2_RS6_dis (select U2_RS_dis (_ bv6 3)))
				(U2_RS7_dis (select U2_RS_dis (_ bv7 3)))	
			)			
		;-- Which one to dispatch? priority 0 to 7, and did anything dispatch from RS ?
		(let
			(
				(U2_RS_dis_index
					(ite (= U2_RS0_dis #b1) (_ bv0 3)
					(ite (= U2_RS1_dis #b1) (_ bv1 3)
					(ite (= U2_RS2_dis #b1) (_ bv2 3)
					(ite (= U2_RS3_dis #b1) (_ bv3 3)
					(ite (= U2_RS4_dis #b1) (_ bv4 3) 
					(ite (= U2_RS5_dis #b1) (_ bv5 3) 
					(ite (= U2_RS6_dis #b1) (_ bv6 3) 
					(ite (= U2_RS7_dis #b1) (_ bv7 3) 
					(_ bv0 3) 
					))))))))
				)
				(U2_RS_entry_dispatched
					(ite (= U2_RS0_dis #b1) (_ bv1 1)
					(ite (= U2_RS1_dis #b1) (_ bv1 1)
					(ite (= U2_RS2_dis #b1) (_ bv1 1)
					(ite (= U2_RS3_dis #b1) (_ bv1 1)
					(ite (= U2_RS4_dis #b1) (_ bv1 1) 
					(ite (= U2_RS5_dis #b1) (_ bv1 1) 
					(ite (= U2_RS6_dis #b1) (_ bv1 1) 
					(ite (= U2_RS7_dis #b1) (_ bv1 1)  
					(_ bv0 1)
					))))))))
				)
			)			
		;-- Information from the entry that dispatched
		(let
			(
				(U2_RS_dis_vj (select U2_RS_vj U2_RS_dis_index))
				(U2_RS_dis_vk (select U2_RS_vk U2_RS_dis_index))
				(U2_RS_dis_qj (select U2_RS_qj U2_RS_dis_index))
				(U2_RS_dis_qk (select U2_RS_qk U2_RS_dis_index))
				(U2_RS_dis_op (select U2_RS_op U2_RS_dis_index))
				(U2_RS_dis_imm (select U2_RS_imm U2_RS_dis_index))
				(U2_RS_dis_ROB_dst (select U2_RS_ROB_dst U2_RS_dis_index))
			)			
		;-- Results from ALU units
		(let
			(
				(U2_RS_result (ALU U2_RS_dis_vj U2_RS_dis_vk U2_RS_dis_imm U2_RS_dis_op))
			)			
		(let
			(
				(U2_ROB_result_update (store U2_ROB_result U2_RS_dis_ROB_dst U2_RS_result))
				(U2_ROB_done_update (store U2_ROB_done U2_RS_dis_ROB_dst (_ bv1 1)))
				(U2_ROB_exception_update (store U2_ROB_exception U2_RS_dis_ROB_dst (_ bv1 1)))
			)			
		;-- Update the ROB if anything dispatched
		;-- ROB gets exception if branch prediciton was incorrrect (Result = 1)
		(let
			(
				(U3_ROB_result (ite (= U2_RS_entry_dispatched #b1) U2_ROB_result_update U2_ROB_result))
				(U3_ROB_done (ite (= U2_RS_entry_dispatched #b1) U2_ROB_done_update U2_ROB_done))
				(U3_ROB_exception (ite (and (= U2_RS_dis_op Branch) (= U2_RS_result 1) (= U2_RS_entry_dispatched #b1)) U2_ROB_exception_update U2_ROB_exception))
			)			
		;-- RS entry to be cleared 
		(let
			(
				(U2_RS_op_update (store U2_RS_op U2_RS_dis_index 0))
				(U2_RS_ROB_dst_update (store U2_RS_ROB_dst U2_RS_dis_index (_ bv0 6)))
				(U2_RS_vj_update (store U2_RS_vj U2_RS_dis_index 0))
				(U2_RS_vk_update (store U2_RS_vk U2_RS_dis_index 0))
				(U2_RS_qj_update (store U2_RS_qj U2_RS_dis_index (_ bv0 6)))
				(U2_RS_qk_update (store U2_RS_qk U2_RS_dis_index (_ bv0 6)))
				(U2_RS_imm_update (store U2_RS_imm U2_RS_dis_index 0))
				(U2_RS_dis_update (store U2_RS_dis U2_RS_dis_index (_ bv0 1)))
				(U2_RS_busy_update (store U2_RS_busy U2_RS_dis_index (_ bv0 1)))
			)
		;-- RS's dispatched entry gets cleared if it was dispatched
		(let
			(
				(U3_RS_op (ite (= U2_RS_entry_dispatched #b1) U2_RS_op_update U2_RS_op))
				(U3_RS_ROB_dst (ite (= U2_RS_entry_dispatched #b1) U2_RS_ROB_dst_update U2_RS_ROB_dst))
				(U3_RS_vj (ite (= U2_RS_entry_dispatched #b1) U2_RS_vj_update U2_RS_vj))
				(U3_RS_vk (ite (= U2_RS_entry_dispatched #b1) U2_RS_vk_update U2_RS_vk))
				(U3_RS_qj (ite (= U2_RS_entry_dispatched #b1) U2_RS_qj_update U2_RS_qj))
				(U3_RS_qk (ite (= U2_RS_entry_dispatched #b1) U2_RS_qk_update U2_RS_qk))
				(U3_RS_imm (ite (= U2_RS_entry_dispatched #b1) U2_RS_imm_update U2_RS_imm))
				(U3_RS_dis (ite (= U2_RS_entry_dispatched #b1) U2_RS_dis_update U2_RS_dis))
				(U3_RS_busy (ite (= U2_RS_entry_dispatched #b1) U2_RS_busy_update U2_RS_busy))
			)			
		;--========	LSQ's Turn for the same process
		(let
			(
				(U2_LSQ0_dis (select U2_LSQ_dis (_ bv0 4)))
				(U2_LSQ1_dis (select U2_LSQ_dis (_ bv1 4)))
				(U2_LSQ2_dis (select U2_LSQ_dis (_ bv2 4)))
				(U2_LSQ3_dis (select U2_LSQ_dis (_ bv3 4)))
				(U2_LSQ4_dis (select U2_LSQ_dis (_ bv4 4)))
				(U2_LSQ5_dis (select U2_LSQ_dis (_ bv5 4)))
				(U2_LSQ6_dis (select U2_LSQ_dis (_ bv6 4)))
				(U2_LSQ7_dis (select U2_LSQ_dis (_ bv7 4)))
				(U2_LSQ8_dis (select U2_LSQ_dis (_ bv8 4)))
				(U2_LSQ9_dis (select U2_LSQ_dis (_ bv9 4)))
				(U2_LSQ10_dis (select U2_LSQ_dis (_ bv10 4)))
				(U2_LSQ11_dis (select U2_LSQ_dis (_ bv11 4)))
				(U2_LSQ12_dis (select U2_LSQ_dis (_ bv12 4)))
				(U2_LSQ13_dis (select U2_LSQ_dis (_ bv13 4)))
				(U2_LSQ14_dis (select U2_LSQ_dis (_ bv14 4)))
				(U2_LSQ15_dis (select U2_LSQ_dis (_ bv15 4)))
			)			
		(let
			(
				(U2_LSQ_dis_index
					(ite (= U2_LSQ0_dis #b1) (_ bv0 4)
					(ite (= U2_LSQ1_dis #b1) (_ bv1 4)
					(ite (= U2_LSQ2_dis #b1) (_ bv2 4)
					(ite (= U2_LSQ3_dis #b1) (_ bv3 4)
					(ite (= U2_LSQ4_dis #b1) (_ bv4 4) 
					(ite (= U2_LSQ5_dis #b1) (_ bv5 4) 
					(ite (= U2_LSQ6_dis #b1) (_ bv6 4) 
					(ite (= U2_LSQ7_dis #b1) (_ bv7 4) 
					(ite (= U2_LSQ8_dis #b1) (_ bv8 4)
					(ite (= U2_LSQ9_dis #b1) (_ bv9 4)
					(ite (= U2_LSQ10_dis #b1) (_ bv10 4)
					(ite (= U2_LSQ11_dis #b1) (_ bv11 4)
					(ite (= U2_LSQ12_dis #b1) (_ bv12 4) 
					(ite (= U2_LSQ13_dis #b1) (_ bv13 4) 
					(ite (= U2_LSQ14_dis #b1) (_ bv14 4) 
					(ite (= U2_LSQ15_dis #b1) (_ bv15 4)
					(_ bv0 4)
					))))))))))))))))
					
				)
				(U2_LSQ_entry_dispatched
					(ite (= U2_LSQ0_dis #b1) (_ bv1 1)
					(ite (= U2_LSQ1_dis #b1) (_ bv1 1)
					(ite (= U2_LSQ2_dis #b1) (_ bv1 1)
					(ite (= U2_LSQ3_dis #b1) (_ bv1 1)
					(ite (= U2_LSQ4_dis #b1) (_ bv1 1) 
					(ite (= U2_LSQ5_dis #b1) (_ bv1 1) 
					(ite (= U2_LSQ6_dis #b1) (_ bv1 1) 
					(ite (= U2_LSQ7_dis #b1) (_ bv1 1) 
					(ite (= U2_LSQ8_dis #b1) (_ bv1 1)
					(ite (= U2_LSQ9_dis #b1) (_ bv1 1)
					(ite (= U2_LSQ10_dis #b1) (_ bv1 1)
					(ite (= U2_LSQ11_dis #b1) (_ bv1 1)
					(ite (= U2_LSQ12_dis #b1) (_ bv1 1) 
					(ite (= U2_LSQ13_dis #b1) (_ bv1 1) 
					(ite (= U2_LSQ14_dis #b1) (_ bv1 1) 
					(ite (= U2_LSQ15_dis #b1) (_ bv1 1) 
					(_ bv0 1)
					))))))))))))))))
				)
			)			
		;-- Information from the LSQ's dispatched entry
		(let
			(
				(U2_LSQ_dis_vj (select U2_LSQ_vj U2_LSQ_dis_index))
				(U2_LSQ_dis_vk (select U2_LSQ_vk U2_LSQ_dis_index))
				(U2_LSQ_dis_qj (select U2_LSQ_qj U2_LSQ_dis_index))
				(U2_LSQ_dis_qk (select U2_LSQ_qk U2_LSQ_dis_index))
				(U2_LSQ_dis_op (select U2_LSQ_op U2_LSQ_dis_index))
				(U2_LSQ_dis_imm (select U2_LSQ_imm U2_LSQ_dis_index))
				(U2_LSQ_dis_ROB_dst (select U2_LSQ_ROB_dst U2_LSQ_dis_index))
			)			
		;-- Generate the addresses from Load Store units
		(let
			(
				(address (LSU U2_LSQ_dis_vj U2_LSQ_dis_vk U2_LSQ_dis_imm U2_LSQ_dis_op))
			)			
		;-- Get the Object_ID, Bounds, TC and SC bits using address
		(let	
			(
				(objectID (Object_ID address))
				(Lower_Bound (Base address))
				(Upper_Bound (Bound address))
				
				(pointerID (pointer_ID address))
				(TC_bit (pointer_TC address))
				(SC_bit (pointer_SC address))
			)			
		;-- TC and SC Check
			(let
			(
				(SC_Flag (ite (and (or (> address Lower_Bound ) (= Trojan Trigger)) (< address Upper_Bound )) (_ bv1 1) (_ bv0 1))) ;make it geq
				(TC_Flag (ite (= objectID pointerID) (_ bv1 1) (_ bv0 1)))
			)			
		;--Temp variables 1 if check had to be performed and passed, 0 if failed, also 1 is no check was needed
		(let
			(
				(SC_pass
					(ite (and (= SC_bit #b1) (= SC_Flag #b1)) (_ bv1 1)	;--Needs check and passed
					(ite (= SC_bit #b0) (_ bv1 1)	;--no checking required
					(_ bv0 1)))	;--check failed
				)
				(TC_pass
					(ite (and (= TC_bit #b1) (= TC_Flag #b1)) (_ bv1 1)	;--Needs check and passed
					(ite (= TC_bit #b0) (_ bv1 1)	;--no checking required
					(_ bv0 1)))	;--check failed
				)
			)			
		;-- Get the currect cache state
		(let
			(
				(U2_Cache0_Tag (select U2_CacheL1_Tag (_ bv0 2)))
				(U2_Cache0_Data (select U2_CacheL1_Data (_ bv0 2)))
				(U2_Cache0_Valid (select U2_CacheL1_Valid (_ bv0 2)))
				(U2_Cache1_Tag (select U2_CacheL1_Tag (_ bv1 2)))
				(U2_Cache1_Data (select U2_CacheL1_Data (_ bv1 2)))
				(U2_Cache1_Valid (select U2_CacheL1_Valid (_ bv1 2)))
				(U2_Cache2_Tag (select U2_CacheL1_Tag (_ bv2 2)))
				(U2_Cache2_Data (select U2_CacheL1_Data (_ bv2 2)))
				(U2_Cache2_Valid (select U2_CacheL1_Valid (_ bv2 2)))
				(U2_Cache3_Tag (select U2_CacheL1_Tag (_ bv3 2)))
				(U2_Cache3_Data (select U2_CacheL1_Data (_ bv3 2)))
				(U2_Cache3_Valid (select U2_CacheL1_Valid (_ bv3 2)))
			)			
		;-- Get the Load value from DM (will select between this one and cache later)
		;-- Check for cache hit
		;-- Is there any free cache line ? if not line 0 will get overwriteen incase of a cache miss
		(let
			(
				(LOAD_Value (select U2_DM address))
				(U2_Cache0_Hit_Load (ite (and (= U2_Cache0_Valid #b1) (= U2_Cache0_Tag address) ) (_ bv1 1) (_ bv0 1)))
				(U2_Cache1_Hit_Load (ite (and (= U2_Cache1_Valid #b1) (= U2_Cache1_Tag address) ) (_ bv1 1) (_ bv0 1)))
				(U2_Cache2_Hit_Load (ite (and (= U2_Cache2_Valid #b1) (= U2_Cache2_Tag address) ) (_ bv1 1) (_ bv0 1)))
				(U2_Cache3_Hit_Load (ite (and (= U2_Cache3_Valid #b1) (= U2_Cache3_Tag address) ) (_ bv1 1) (_ bv0 1)))	
				
				(available_cline 
					(ite (= U2_Cache0_Valid #b0) (_ bv0 2)	;check if U3_Cache line 0 is free
					(ite (= U2_Cache1_Valid #b0) (_ bv1 2)	;check if U3_Cache line 1 is free
					(ite (= U2_Cache2_Valid #b0) (_ bv2 2)	;check if U3_Cache line 2 is free
					(ite (= U2_Cache3_Valid #b0) (_ bv3 2)	;check if U3_Cache line 3 is free
					(_ bv0 2)							;Badluck nothing is free, bye bye U3_Cache line 0 
					))))
				)
			)			
		;-- Was there a cache hit ? 
		;-- Is op is load then laodvalue for cache if store then vk value
		(let
			(
				(cache_update_value 
					(ite (= U2_LSQ_dis_op SLoad) LOAD_Value
					(ite (= U2_LSQ_dis_op SStore) U2_LSQ_dis_vk
					0))
				)
				(U2_Cache_Hit (bvor U2_Cache0_Hit_Load U2_Cache1_Hit_Load U2_Cache2_Hit_Load U2_Cache3_Hit_Load))
			)			
		;-- If its a load instruction and there was cache hit, take the result from cache, else use the laod value from DM
		(let
			(
				(U2_LSQ_result
					(ite (and (= U2_Cache0_Hit_Load #b1) (= U2_LSQ_dis_op SLoad)) U2_Cache0_Data
					(ite (and (= U2_Cache1_Hit_Load #b1) (= U2_LSQ_dis_op SLoad)) U2_Cache1_Data
					(ite (and (= U2_Cache2_Hit_Load #b1) (= U2_LSQ_dis_op SLoad)) U2_Cache2_Data
					(ite (and (= U2_Cache3_Hit_Load #b1) (= U2_LSQ_dis_op SLoad)) U2_Cache3_Data
					(ite (and (= U2_Cache_Hit #b0) (= U2_LSQ_dis_op SLoad)) LOAD_Value
					0)))))
				)
			)			
		;-- Generate the potential ROB update state, (store instruction's result is the Vk/RF[rt] value)
		(let
			(
				(U2_ROB_destination_update (store U2_ROB_destination U2_LSQ_dis_ROB_dst address))
				(U2_ROB_result_load (store U3_ROB_result U2_LSQ_dis_ROB_dst U2_LSQ_result))
				(U2_ROB_result_store (store U3_ROB_result U2_LSQ_dis_ROB_dst U2_LSQ_dis_vk))
				(U2_ROB_done_update (store U3_ROB_done U2_LSQ_dis_ROB_dst (_ bv1 1)))
				
				(U2_ROB_Maddress_update 
					(ite (= U2_LSQ_dis_op SLoad) (store U2_ROB_Maddress U2_LSQ_dis_ROB_dst address)	;--store the load address in rob for future check
					(ite (= U2_LSQ_dis_op SStore) (store U2_ROB_Maddress U2_LSQ_dis_ROB_dst address)	;--store the load address in rob for future check
				U2_ROB_Maddress))
				)
			)
		;-- If anything dispatched then update the ROB
		(let
			(
				(U3_ROB_destination 
					(ite (and (= U2_LSQ_entry_dispatched #b1) (= U2_LSQ_dis_op SStore)) U2_ROB_destination_update 
					U2_ROB_destination)
				)
				(U3_ROB_result
					(ite (and (= U2_LSQ_entry_dispatched #b1) (= U2_LSQ_dis_op SLoad)) U2_ROB_result_load
					(ite (and (= U2_LSQ_entry_dispatched #b1) (= U2_LSQ_dis_op SStore)) U2_ROB_result_store
					U3_ROB_result
					))
				)
				(U3_ROB_done (ite (= U2_LSQ_entry_dispatched #b1) U2_ROB_done_update U3_ROB_done))		
				
				(U3_ROB_Maddress (ite (= U2_LSQ_entry_dispatched #b1) U2_ROB_Maddress_update U2_ROB_Maddress))			
			)
		;-- Generating the LSQ emptied entry state and cache miss update state 
		(let
			(
				(U2_LSQ_op_update (store U2_LSQ_op U2_LSQ_dis_index 0))
				(U2_LSQ_ROB_dst_update (store U2_LSQ_ROB_dst U2_LSQ_dis_index (_ bv0 6)))
				(U2_LSQ_vj_update (store U2_LSQ_vj U2_LSQ_dis_index 0))
				(U2_LSQ_vk_update (store U2_LSQ_vk U2_LSQ_dis_index 0))
				(U2_LSQ_qj_update (store U2_LSQ_qj U2_LSQ_dis_index (_ bv0 6)))
				(U2_LSQ_qk_update (store U2_LSQ_qk U2_LSQ_dis_index (_ bv0 6)))
				(U2_LSQ_imm_update (store U2_LSQ_imm U2_LSQ_dis_index 0))
				(U2_LSQ_dis_update (store U2_LSQ_dis U2_LSQ_dis_index (_ bv0 1)))
				(U2_LSQ_busy_update (store U2_LSQ_busy U2_LSQ_dis_index (_ bv0 1)))

				(U2_cacheData_miss_update (store U2_CacheL1_Data available_cline cache_update_value))
				(U2_cacheTag_miss_update (store U2_CacheL1_Tag available_cline address))
				(U2_cacheValid_miss_update (store U2_CacheL1_Valid available_cline (_ bv1 1)))
			)			
		;-- If anything dispatched, clear that Entry
		;-- If there was a cache miss for load then update the cache
		(let
			(
				(U3_LSQ_op (ite (and (= U2_LSQ_entry_dispatched #b1)) U2_LSQ_op_update U2_LSQ_op))
				(U3_LSQ_ROB_dst (ite (and (= U2_LSQ_entry_dispatched #b1)) U2_LSQ_ROB_dst_update U2_LSQ_ROB_dst))
				(U3_LSQ_vj (ite (and (= U2_LSQ_entry_dispatched #b1)) U2_LSQ_vj_update U2_LSQ_vj))
				(U3_LSQ_vk (ite (and (= U2_LSQ_entry_dispatched #b1)) U2_LSQ_vk_update U2_LSQ_vk))
				(U3_LSQ_qj (ite (and (= U2_LSQ_entry_dispatched #b1)) U2_LSQ_qj_update U2_LSQ_qj))
				(U3_LSQ_qk (ite (and (= U2_LSQ_entry_dispatched #b1)) U2_LSQ_qk_update U2_LSQ_qk))
				(U3_LSQ_imm (ite (and (= U2_LSQ_entry_dispatched #b1)) U2_LSQ_imm_update U2_LSQ_imm))
				(U3_LSQ_dis (ite (and (= U2_LSQ_entry_dispatched #b1)) U2_LSQ_dis_update U2_LSQ_dis))
				(U3_LSQ_busy (ite (and (= U2_LSQ_entry_dispatched #b1)) U2_LSQ_busy_update U2_LSQ_busy))
						
				(U3_CacheL1_Data 
					(ite (and (or (= SStore U2_LSQ_dis_op) (= SLoad U2_LSQ_dis_op)) (= U2_LSQ_entry_dispatched #b1) (= U2_Cache_Hit #b0) (= SC_pass #b1) (= TC_pass #b1)) U2_cacheData_miss_update 					
					U2_CacheL1_Data)
				)
				(U3_CacheL1_Tag 
					(ite (and (or (= SStore U2_LSQ_dis_op) (= SLoad U2_LSQ_dis_op)) (= U2_LSQ_entry_dispatched #b1) (= U2_Cache_Hit #b0) (= SC_pass #b1) (= TC_pass #b1)) U2_cacheTag_miss_update 	
						U2_CacheL1_Tag)
				)
				(U3_CacheL1_Valid 
					(ite (and (or (= SStore U2_LSQ_dis_op) (= SLoad U2_LSQ_dis_op)) (= U2_LSQ_entry_dispatched #b1) (= U2_Cache_Hit #b0) (= SC_pass #b1) (= TC_pass #b1)) U2_cacheValid_miss_update 	
						U2_CacheL1_Valid)
				)
			)			
		;--========== Perform the update process again which will also perform broadcast step as its part
		;-- Get the currect RS and LSQ state
		(let
			(
				(U3_RS0_busy (select U3_RS_busy (_ bv0 3)))
				(U3_RS0_qj (select U3_RS_qj (_ bv0 3)))
				(U3_RS0_qk (select U3_RS_qk (_ bv0 3)))
				(U3_RS1_busy (select U3_RS_busy (_ bv1 3)))
				(U3_RS1_qj (select U3_RS_qj (_ bv1 3)))
				(U3_RS1_qk (select U3_RS_qk (_ bv1 3)))
				(U3_RS2_busy (select U3_RS_busy (_ bv2 3)))
				(U3_RS2_qj (select U3_RS_qj (_ bv2 3)))
				(U3_RS2_qk (select U3_RS_qk (_ bv2 3)))
				(U3_RS3_busy (select U3_RS_busy (_ bv3 3)))
				(U3_RS3_qj (select U3_RS_qj (_ bv3 3)))
				(U3_RS3_qk (select U3_RS_qk (_ bv3 3)))
				(U3_RS4_busy (select U3_RS_busy (_ bv4 3)))
				(U3_RS4_qj (select U3_RS_qj (_ bv4 3)))
				(U3_RS4_qk (select U3_RS_qk (_ bv4 3)))
				(U3_RS5_busy (select U3_RS_busy (_ bv5 3)))
				(U3_RS5_qj (select U3_RS_qj (_ bv5 3)))
				(U3_RS5_qk (select U3_RS_qk (_ bv5 3)))
				(U3_RS6_busy (select U3_RS_busy (_ bv6 3)))
				(U3_RS6_qj (select U3_RS_qj (_ bv6 3)))
				(U3_RS6_qk (select U3_RS_qk (_ bv6 3)))
				(U3_RS7_busy (select U3_RS_busy (_ bv7 3)))
				(U3_RS7_qj (select U3_RS_qj (_ bv7 3)))
				(U3_RS7_qk (select U3_RS_qk (_ bv7 3)))


								
				(U3_LSQ0_busy (select U3_LSQ_busy (_ bv0 4)))
				(U3_LSQ0_qj (select U3_LSQ_qj (_ bv0 4)))
				(U3_LSQ0_qk (select U3_LSQ_qk (_ bv0 4)))
				(U3_LSQ1_busy (select U3_LSQ_busy (_ bv1 4)))
				(U3_LSQ1_qj (select U3_LSQ_qj (_ bv1 4)))
				(U3_LSQ1_qk (select U3_LSQ_qk (_ bv1 4)))
				(U3_LSQ2_busy (select U3_LSQ_busy (_ bv2 4)))
				(U3_LSQ2_qj (select U3_LSQ_qj (_ bv2 4)))
				(U3_LSQ2_qk (select U3_LSQ_qk (_ bv2 4)))
				(U3_LSQ3_busy (select U3_LSQ_busy (_ bv3 4)))
				(U3_LSQ3_qj (select U3_LSQ_qj (_ bv3 4)))
				(U3_LSQ3_qk (select U3_LSQ_qk (_ bv3 4)))
				(U3_LSQ4_busy (select U3_LSQ_busy (_ bv4 4)))
				(U3_LSQ4_qj (select U3_LSQ_qj (_ bv4 4)))
				(U3_LSQ4_qk (select U3_LSQ_qk (_ bv4 4)))
				(U3_LSQ5_busy (select U3_LSQ_busy (_ bv5 4)))
				(U3_LSQ5_qj (select U3_LSQ_qj (_ bv5 4)))
				(U3_LSQ5_qk (select U3_LSQ_qk (_ bv5 4)))
				(U3_LSQ6_busy (select U3_LSQ_busy (_ bv6 4)))
				(U3_LSQ6_qj (select U3_LSQ_qj (_ bv6 4)))
				(U3_LSQ6_qk (select U3_LSQ_qk (_ bv6 4)))
				(U3_LSQ7_busy (select U3_LSQ_busy (_ bv7 4)))
				(U3_LSQ7_qj (select U3_LSQ_qj (_ bv7 4)))
				(U3_LSQ7_qk (select U3_LSQ_qk (_ bv7 4)))

                (U3_LSQ8_busy (select U3_LSQ_busy (_ bv8 4)))
				(U3_LSQ8_qj (select U3_LSQ_qj (_ bv8 4)))
				(U3_LSQ8_qk (select U3_LSQ_qk (_ bv8 4)))
				(U3_LSQ9_busy (select U3_LSQ_busy (_ bv9 4)))
				(U3_LSQ9_qj (select U3_LSQ_qj (_ bv9 4)))
				(U3_LSQ9_qk (select U3_LSQ_qk (_ bv9 4)))
				(U3_LSQ10_busy (select U3_LSQ_busy (_ bv10 4)))
				(U3_LSQ10_qj (select U3_LSQ_qj (_ bv10 4)))
				(U3_LSQ10_qk (select U3_LSQ_qk (_ bv10 4)))
				(U3_LSQ11_busy (select U3_LSQ_busy (_ bv11 4)))
				(U3_LSQ11_qj (select U3_LSQ_qj (_ bv11 4)))
				(U3_LSQ11_qk (select U3_LSQ_qk (_ bv11 4)))
				(U3_LSQ12_busy (select U3_LSQ_busy (_ bv12 4)))
				(U3_LSQ12_qj (select U3_LSQ_qj (_ bv12 4)))
				(U3_LSQ12_qk (select U3_LSQ_qk (_ bv12 4)))
				(U3_LSQ13_busy (select U3_LSQ_busy (_ bv13 4)))
				(U3_LSQ13_qj (select U3_LSQ_qj (_ bv13 4)))
				(U3_LSQ13_qk (select U3_LSQ_qk (_ bv13 4)))
				(U3_LSQ14_busy (select U3_LSQ_busy (_ bv14 4)))
				(U3_LSQ14_qj (select U3_LSQ_qj (_ bv14 4)))
				(U3_LSQ14_qk (select U3_LSQ_qk (_ bv14 4)))
				(U3_LSQ15_busy (select U3_LSQ_busy (_ bv15 4)))
				(U3_LSQ15_qj (select U3_LSQ_qj (_ bv15 4)))
				(U3_LSQ15_qk (select U3_LSQ_qk (_ bv15 4)))	
			)			
		;-- Get ROB information from Tag locations
		(let
			(
				(U3_RS0_qj_ROB_done (select U3_ROB_done U3_RS0_qj))
				(U3_RS0_qj_ROB_result (select U3_ROB_result U3_RS0_qj))
				(U3_RS0_qk_ROB_done (select U3_ROB_done U3_RS0_qk))
				(U3_RS0_qk_ROB_result (select U3_ROB_result U3_RS0_qk))
				(U3_RS1_qj_ROB_done (select U3_ROB_done U3_RS1_qj))
				(U3_RS1_qj_ROB_result (select U3_ROB_result U3_RS1_qj))
				(U3_RS1_qk_ROB_done (select U3_ROB_done U3_RS1_qk))
				(U3_RS1_qk_ROB_result (select U3_ROB_result U3_RS1_qk))
				(U3_RS2_qj_ROB_done (select U3_ROB_done U3_RS2_qj))
				(U3_RS2_qj_ROB_result (select U3_ROB_result U3_RS2_qj))
				(U3_RS2_qk_ROB_done (select U3_ROB_done U3_RS2_qk))
				(U3_RS2_qk_ROB_result (select U3_ROB_result U3_RS2_qk))
				(U3_RS3_qj_ROB_done (select U3_ROB_done U3_RS3_qj))
				(U3_RS3_qj_ROB_result (select U3_ROB_result U3_RS3_qj))
				(U3_RS3_qk_ROB_done (select U3_ROB_done U3_RS3_qk))
				(U3_RS3_qk_ROB_result (select U3_ROB_result U3_RS3_qk))
				(U3_RS4_qj_ROB_done (select U3_ROB_done U3_RS4_qj))
				(U3_RS4_qj_ROB_result (select U3_ROB_result U3_RS4_qj))
				(U3_RS4_qk_ROB_done (select U3_ROB_done U3_RS4_qk))
				(U3_RS4_qk_ROB_result (select U3_ROB_result U3_RS4_qk))
				(U3_RS5_qj_ROB_done (select U3_ROB_done U3_RS5_qj))
				(U3_RS5_qj_ROB_result (select U3_ROB_result U3_RS5_qj))
				(U3_RS5_qk_ROB_done (select U3_ROB_done U3_RS5_qk))
				(U3_RS5_qk_ROB_result (select U3_ROB_result U3_RS5_qk))
				(U3_RS6_qj_ROB_done (select U3_ROB_done U3_RS6_qj))
				(U3_RS6_qj_ROB_result (select U3_ROB_result U3_RS6_qj))
				(U3_RS6_qk_ROB_done (select U3_ROB_done U3_RS6_qk))
				(U3_RS6_qk_ROB_result (select U3_ROB_result U3_RS6_qk))
				(U3_RS7_qj_ROB_done (select U3_ROB_done U3_RS7_qj))
				(U3_RS7_qj_ROB_result (select U3_ROB_result U3_RS7_qj))
				(U3_RS7_qk_ROB_done (select U3_ROB_done U3_RS7_qk))
				(U3_RS7_qk_ROB_result (select U3_ROB_result U3_RS7_qk))
				
				(U3_LSQ0_qj_ROB_done (select U3_ROB_done U3_LSQ0_qj))
				(U3_LSQ0_qj_ROB_result (select U3_ROB_result U3_LSQ0_qj))
				(U3_LSQ0_qk_ROB_done (select U3_ROB_done U3_LSQ0_qk))
				(U3_LSQ0_qk_ROB_result (select U3_ROB_result U3_LSQ0_qk))
				(U3_LSQ1_qj_ROB_done (select U3_ROB_done U3_LSQ1_qj))
				(U3_LSQ1_qj_ROB_result (select U3_ROB_result U3_LSQ1_qj))
				(U3_LSQ1_qk_ROB_done (select U3_ROB_done U3_LSQ1_qk))
				(U3_LSQ1_qk_ROB_result (select U3_ROB_result U3_LSQ1_qk))
				(U3_LSQ2_qj_ROB_done (select U3_ROB_done U3_LSQ2_qj))
				(U3_LSQ2_qj_ROB_result (select U3_ROB_result U3_LSQ2_qj))
				(U3_LSQ2_qk_ROB_done (select U3_ROB_done U3_LSQ2_qk))
				(U3_LSQ2_qk_ROB_result (select U3_ROB_result U3_LSQ2_qk))
				(U3_LSQ3_qj_ROB_done (select U3_ROB_done U3_LSQ3_qj))
				(U3_LSQ3_qj_ROB_result (select U3_ROB_result U3_LSQ3_qj))
				(U3_LSQ3_qk_ROB_done (select U3_ROB_done U3_LSQ3_qk))
				(U3_LSQ3_qk_ROB_result (select U3_ROB_result U3_LSQ3_qk))
				(U3_LSQ4_qj_ROB_done (select U3_ROB_done U3_LSQ4_qj))
				(U3_LSQ4_qj_ROB_result (select U3_ROB_result U3_LSQ4_qj))
				(U3_LSQ4_qk_ROB_done (select U3_ROB_done U3_LSQ4_qk))
				(U3_LSQ4_qk_ROB_result (select U3_ROB_result U3_LSQ4_qk))
				(U3_LSQ5_qj_ROB_done (select U3_ROB_done U3_LSQ5_qj))
				(U3_LSQ5_qj_ROB_result (select U3_ROB_result U3_LSQ5_qj))
				(U3_LSQ5_qk_ROB_done (select U3_ROB_done U3_LSQ5_qk))
				(U3_LSQ5_qk_ROB_result (select U3_ROB_result U3_LSQ5_qk))
				(U3_LSQ6_qj_ROB_done (select U3_ROB_done U3_LSQ6_qj))
				(U3_LSQ6_qj_ROB_result (select U3_ROB_result U3_LSQ6_qj))
				(U3_LSQ6_qk_ROB_done (select U3_ROB_done U3_LSQ6_qk))
				(U3_LSQ6_qk_ROB_result (select U3_ROB_result U3_LSQ6_qk))
				(U3_LSQ7_qj_ROB_done (select U3_ROB_done U3_LSQ7_qj))
				(U3_LSQ7_qj_ROB_result (select U3_ROB_result U3_LSQ7_qj))
				(U3_LSQ7_qk_ROB_done (select U3_ROB_done U3_LSQ7_qk))
				(U3_LSQ7_qk_ROB_result (select U3_ROB_result U3_LSQ7_qk))
				(U3_LSQ8_qj_ROB_done (select U3_ROB_done U3_LSQ8_qj))
				(U3_LSQ8_qj_ROB_result (select U3_ROB_result U3_LSQ8_qj))
				(U3_LSQ8_qk_ROB_done (select U3_ROB_done U3_LSQ8_qk))
				(U3_LSQ8_qk_ROB_result (select U3_ROB_result U3_LSQ8_qk))
				(U3_LSQ9_qj_ROB_done (select U3_ROB_done U3_LSQ9_qj))
				(U3_LSQ9_qj_ROB_result (select U3_ROB_result U3_LSQ9_qj))
				(U3_LSQ9_qk_ROB_done (select U3_ROB_done U3_LSQ9_qk))
				(U3_LSQ9_qk_ROB_result (select U3_ROB_result U3_LSQ9_qk))
				(U3_LSQ10_qj_ROB_done (select U3_ROB_done U3_LSQ10_qj))
				(U3_LSQ10_qj_ROB_result (select U3_ROB_result U3_LSQ10_qj))
				(U3_LSQ10_qk_ROB_done (select U3_ROB_done U3_LSQ10_qk))
				(U3_LSQ10_qk_ROB_result (select U3_ROB_result U3_LSQ10_qk))
				(U3_LSQ11_qj_ROB_done (select U3_ROB_done U3_LSQ11_qj))
				(U3_LSQ11_qj_ROB_result (select U3_ROB_result U3_LSQ11_qj))
				(U3_LSQ11_qk_ROB_done (select U3_ROB_done U3_LSQ11_qk))
				(U3_LSQ11_qk_ROB_result (select U3_ROB_result U3_LSQ11_qk))
				(U3_LSQ12_qj_ROB_done (select U3_ROB_done U3_LSQ12_qj))
				(U3_LSQ12_qj_ROB_result (select U3_ROB_result U3_LSQ12_qj))
				(U3_LSQ12_qk_ROB_done (select U3_ROB_done U3_LSQ12_qk))
				(U3_LSQ12_qk_ROB_result (select U3_ROB_result U3_LSQ12_qk))
				(U3_LSQ13_qj_ROB_done (select U3_ROB_done U3_LSQ13_qj))
				(U3_LSQ13_qj_ROB_result (select U3_ROB_result U3_LSQ13_qj))
				(U3_LSQ13_qk_ROB_done (select U3_ROB_done U3_LSQ13_qk))
				(U3_LSQ13_qk_ROB_result (select U3_ROB_result U3_LSQ13_qk))
				(U3_LSQ14_qj_ROB_done (select U3_ROB_done U3_LSQ14_qj))
				(U3_LSQ14_qj_ROB_result (select U3_ROB_result U3_LSQ14_qj))
				(U3_LSQ14_qk_ROB_done (select U3_ROB_done U3_LSQ14_qk))
				(U3_LSQ14_qk_ROB_result (select U3_ROB_result U3_LSQ14_qk))
				(U3_LSQ15_qj_ROB_done (select U3_ROB_done U3_LSQ15_qj))
				(U3_LSQ15_qj_ROB_result (select U3_ROB_result U3_LSQ15_qj))
				(U3_LSQ15_qk_ROB_done (select U3_ROB_done U3_LSQ15_qk))
				(U3_LSQ15_qk_ROB_result (select U3_ROB_result U3_LSQ15_qk))
			)			
		;-- Perform the update process, same as last time
		(let
			(
				(U3_RS0_vj_update (store U3_RS_vj (_ bv0 3) U3_RS0_qj_ROB_result))
				(U3_RS0_vk_update (store U3_RS_vk (_ bv0 3) U3_RS0_qk_ROB_result))					
				(U3_RS0_qj_update (store U3_RS_qj (_ bv0 3) (_ bv0 6)))	
				(U3_RS0_qk_update (store U3_RS_qk (_ bv0 3) (_ bv0 6)))	
				(U3_LSQ0_vj_update (store U3_LSQ_vj (_ bv0 4) U3_LSQ0_qj_ROB_result))	
				(U3_LSQ0_vk_update (store U3_LSQ_vk (_ bv0 4) U3_LSQ0_qk_ROB_result))	
				(U3_LSQ0_qj_update (store U3_LSQ_qj (_ bv0 4) (_ bv0 6)))	
				(U3_LSQ0_qk_update (store U3_LSQ_qk (_ bv0 4) (_ bv0 6)))	
			)
		(let
			(
				(U3_RS_vj (ite (and (= #b1 U3_RS0_busy) (not (= #b000000 U3_RS0_qj)) (= #b1 U3_RS0_qj_ROB_done)) U3_RS0_vj_update U3_RS_vj))
				(U3_RS_vk (ite (and (= #b1 U3_RS0_busy) (not (= #b000000 U3_RS0_qk)) (= #b1 U3_RS0_qk_ROB_done)) U3_RS0_vk_update U3_RS_vk))
				(U3_RS_qj (ite (and (= #b1 U3_RS0_busy) (not (= #b000000 U3_RS0_qj)) (= #b1 U3_RS0_qj_ROB_done)) U3_RS0_qj_update U3_RS_qj))
				(U3_RS_qk (ite (and (= #b1 U3_RS0_busy) (not (= #b000000 U3_RS0_qk)) (= #b1 U3_RS0_qk_ROB_done)) U3_RS0_qk_update U3_RS_qk))
				(U3_LSQ_vj (ite (and (= #b1 U3_LSQ0_busy) (not (= #b000000 U3_LSQ0_qj)) (= #b1 U3_LSQ0_qj_ROB_done)) U3_LSQ0_vj_update U3_LSQ_vj))
				(U3_LSQ_vk (ite (and (= #b1 U3_LSQ0_busy) (not (= #b000000 U3_LSQ0_qk)) (= #b1 U3_LSQ0_qk_ROB_done)) U3_LSQ0_vk_update U3_LSQ_vk))
				(U3_LSQ_qj (ite (and (= #b1 U3_LSQ0_busy) (not (= #b000000 U3_LSQ0_qj)) (= #b1 U3_LSQ0_qj_ROB_done)) U3_LSQ0_qj_update U3_LSQ_qj))
				(U3_LSQ_qk (ite (and (= #b1 U3_LSQ0_busy) (not (= #b000000 U3_LSQ0_qk)) (= #b1 U3_LSQ0_qk_ROB_done)) U3_LSQ0_qk_update U3_LSQ_qk))
			)			
		(let
			(
				(U3_RS1_vj_update (store U3_RS_vj (_ bv1 3) U3_RS1_qj_ROB_result))
				(U3_RS1_vk_update (store U3_RS_vk (_ bv1 3) U3_RS1_qk_ROB_result))					
				(U3_RS1_qj_update (store U3_RS_qj (_ bv1 3) (_ bv0 6)))	
				(U3_RS1_qk_update (store U3_RS_qk (_ bv1 3) (_ bv0 6)))	
				(U3_LSQ1_vj_update (store U3_LSQ_vj (_ bv1 4) U3_LSQ1_qj_ROB_result))	
				(U3_LSQ1_vk_update (store U3_LSQ_vk (_ bv1 4) U3_LSQ1_qk_ROB_result))	
				(U3_LSQ1_qj_update (store U3_LSQ_qj (_ bv1 4) (_ bv0 6)))	
				(U3_LSQ1_qk_update (store U3_LSQ_qk (_ bv1 4) (_ bv0 6)))	
			)
		(let
			(
				(U3_RS_vj (ite (and (= #b1 U3_RS1_busy) (not (= #b000000 U3_RS1_qj)) (= #b1 U3_RS1_qj_ROB_done)) U3_RS1_vj_update U3_RS_vj))
				(U3_RS_vk (ite (and (= #b1 U3_RS1_busy) (not (= #b000000 U3_RS1_qk)) (= #b1 U3_RS1_qk_ROB_done)) U3_RS1_vk_update U3_RS_vk))
				(U3_RS_qj (ite (and (= #b1 U3_RS1_busy) (not (= #b000000 U3_RS1_qj)) (= #b1 U3_RS1_qj_ROB_done)) U3_RS1_qj_update U3_RS_qj))
				(U3_RS_qk (ite (and (= #b1 U3_RS1_busy) (not (= #b000000 U3_RS1_qk)) (= #b1 U3_RS1_qk_ROB_done)) U3_RS1_qk_update U3_RS_qk))
				(U3_LSQ_vj (ite (and (= #b1 U3_LSQ1_busy) (not (= #b000000 U3_LSQ1_qj)) (= #b1 U3_LSQ1_qj_ROB_done)) U3_LSQ1_vj_update U3_LSQ_vj))
				(U3_LSQ_vk (ite (and (= #b1 U3_LSQ1_busy) (not (= #b000000 U3_LSQ1_qk)) (= #b1 U3_LSQ1_qk_ROB_done)) U3_LSQ1_vk_update U3_LSQ_vk))
				(U3_LSQ_qj (ite (and (= #b1 U3_LSQ1_busy) (not (= #b000000 U3_LSQ1_qj)) (= #b1 U3_LSQ1_qj_ROB_done)) U3_LSQ1_qj_update U3_LSQ_qj))
				(U3_LSQ_qk (ite (and (= #b1 U3_LSQ1_busy) (not (= #b000000 U3_LSQ1_qk)) (= #b1 U3_LSQ1_qk_ROB_done)) U3_LSQ1_qk_update U3_LSQ_qk))
			)			
		(let
			(
				(U3_RS2_vj_update (store U3_RS_vj (_ bv2 3) U3_RS2_qj_ROB_result))	
				(U3_RS2_vk_update (store U3_RS_vk (_ bv2 3) U3_RS2_qk_ROB_result))	
				(U3_RS2_qj_update (store U3_RS_qj (_ bv2 3) (_ bv0 6)))	
				(U3_RS2_qk_update (store U3_RS_qk (_ bv2 3) (_ bv0 6)))	
				(U3_LSQ2_vj_update (store U3_LSQ_vj (_ bv2 4) U3_LSQ2_qj_ROB_result))	
				(U3_LSQ2_vk_update (store U3_LSQ_vk (_ bv2 4) U3_LSQ2_qk_ROB_result))	
				(U3_LSQ2_qj_update (store U3_LSQ_qj (_ bv2 4) (_ bv0 6)))	
				(U3_LSQ2_qk_update (store U3_LSQ_qk (_ bv2 4) (_ bv0 6)))	
			)
		(let
			(
				(U3_RS_vj (ite (and (= #b1 U3_RS2_busy) (not (= #b000000 U3_RS2_qj)) (= #b1 U3_RS2_qj_ROB_done)) U3_RS2_vj_update U3_RS_vj))
				(U3_RS_vk (ite (and (= #b1 U3_RS2_busy) (not (= #b000000 U3_RS2_qk)) (= #b1 U3_RS2_qk_ROB_done)) U3_RS2_vk_update U3_RS_vk))
				(U3_RS_qj (ite (and (= #b1 U3_RS2_busy) (not (= #b000000 U3_RS2_qj)) (= #b1 U3_RS2_qj_ROB_done)) U3_RS2_qj_update U3_RS_qj))
				(U3_RS_qk (ite (and (= #b1 U3_RS2_busy) (not (= #b000000 U3_RS2_qk)) (= #b1 U3_RS2_qk_ROB_done)) U3_RS2_qk_update U3_RS_qk))
				(U3_LSQ_vj (ite (and (= #b1 U3_LSQ2_busy) (not (= #b000000 U3_LSQ2_qj)) (= #b1 U3_LSQ2_qj_ROB_done)) U3_LSQ2_vj_update U3_LSQ_vj))
				(U3_LSQ_vk (ite (and (= #b1 U3_LSQ2_busy) (not (= #b000000 U3_LSQ2_qk)) (= #b1 U3_LSQ2_qk_ROB_done)) U3_LSQ2_vk_update U3_LSQ_vk))
				(U3_LSQ_qj (ite (and (= #b1 U3_LSQ2_busy) (not (= #b000000 U3_LSQ2_qj)) (= #b1 U3_LSQ2_qj_ROB_done)) U3_LSQ2_qj_update U3_LSQ_qj))
				(U3_LSQ_qk (ite (and (= #b1 U3_LSQ2_busy) (not (= #b000000 U3_LSQ2_qk)) (= #b1 U3_LSQ2_qk_ROB_done)) U3_LSQ2_qk_update U3_LSQ_qk))
			)
		(let
			(
				(U3_RS3_vj_update (store U3_RS_vj (_ bv3 3) U3_RS3_qj_ROB_result))	
				(U3_RS3_vk_update (store U3_RS_vk (_ bv3 3) U3_RS3_qk_ROB_result))	
				(U3_RS3_qj_update (store U3_RS_qj (_ bv3 3) (_ bv0 6)))	
				(U3_RS3_qk_update (store U3_RS_qk (_ bv3 3) (_ bv0 6)))	
				(U3_LSQ3_vj_update (store U3_LSQ_vj (_ bv3 4) U3_LSQ3_qj_ROB_result))	
				(U3_LSQ3_vk_update (store U3_LSQ_vk (_ bv3 4) U3_LSQ3_qk_ROB_result))	
				(U3_LSQ3_qj_update (store U3_LSQ_qj (_ bv3 4) (_ bv0 6)))	
				(U3_LSQ3_qk_update (store U3_LSQ_qk (_ bv3 4) (_ bv0 6)))	
			)
		(let
			(
				(U3_RS_vj (ite (and (= #b1 U3_RS3_busy) (not (= #b000000 U3_RS3_qj)) (= #b1 U3_RS3_qj_ROB_done)) U3_RS3_vj_update U3_RS_vj))
				(U3_RS_vk (ite (and (= #b1 U3_RS3_busy) (not (= #b000000 U3_RS3_qk)) (= #b1 U3_RS3_qk_ROB_done)) U3_RS3_vk_update U3_RS_vk))
				(U3_RS_qj (ite (and (= #b1 U3_RS3_busy) (not (= #b000000 U3_RS3_qj)) (= #b1 U3_RS3_qj_ROB_done)) U3_RS3_qj_update U3_RS_qj))
				(U3_RS_qk (ite (and (= #b1 U3_RS3_busy) (not (= #b000000 U3_RS3_qk)) (= #b1 U3_RS3_qk_ROB_done)) U3_RS3_qk_update U3_RS_qk))
				(U3_LSQ_vj (ite (and (= #b1 U3_LSQ3_busy) (not (= #b000000 U3_LSQ3_qj)) (= #b1 U3_LSQ3_qj_ROB_done)) U3_LSQ3_vj_update U3_LSQ_vj))
				(U3_LSQ_vk (ite (and (= #b1 U3_LSQ3_busy) (not (= #b000000 U3_LSQ3_qk)) (= #b1 U3_LSQ3_qk_ROB_done)) U3_LSQ3_vk_update U3_LSQ_vk))
				(U3_LSQ_qj (ite (and (= #b1 U3_LSQ3_busy) (not (= #b000000 U3_LSQ3_qj)) (= #b1 U3_LSQ3_qj_ROB_done)) U3_LSQ3_qj_update U3_LSQ_qj))
				(U3_LSQ_qk (ite (and (= #b1 U3_LSQ3_busy) (not (= #b000000 U3_LSQ3_qk)) (= #b1 U3_LSQ3_qk_ROB_done)) U3_LSQ3_qk_update U3_LSQ_qk))
			)	

		(let
			(
				(U3_RS4_vj_update (store U3_RS_vj (_ bv4 3) U3_RS4_qj_ROB_result))	
				(U3_RS4_vk_update (store U3_RS_vk (_ bv4 3) U3_RS4_qk_ROB_result))	
				(U3_RS4_qj_update (store U3_RS_qj (_ bv4 3) (_ bv0 6)))	
				(U3_RS4_qk_update (store U3_RS_qk (_ bv4 3) (_ bv0 6)))	
				(U3_LSQ4_vj_update (store U3_LSQ_vj (_ bv4 4) U3_LSQ4_qj_ROB_result))	
				(U3_LSQ4_vk_update (store U3_LSQ_vk (_ bv4 4) U3_LSQ4_qk_ROB_result))	
				(U3_LSQ4_qj_update (store U3_LSQ_qj (_ bv4 4) (_ bv0 6)))	
				(U3_LSQ4_qk_update (store U3_LSQ_qk (_ bv4 4) (_ bv0 6)))	
			)
        (let
			(
				(U3_RS_vj (ite (and (= #b1 U3_RS4_busy) (not (= #b000000 U3_RS4_qj)) (= #b1 U3_RS4_qj_ROB_done)) U3_RS4_vj_update U3_RS_vj))
				(U3_RS_vk (ite (and (= #b1 U3_RS4_busy) (not (= #b000000 U3_RS4_qk)) (= #b1 U3_RS4_qk_ROB_done)) U3_RS4_vk_update U3_RS_vk))
				(U3_RS_qj (ite (and (= #b1 U3_RS4_busy) (not (= #b000000 U3_RS4_qj)) (= #b1 U3_RS4_qj_ROB_done)) U3_RS4_qj_update U3_RS_qj))
				(U3_RS_qk (ite (and (= #b1 U3_RS4_busy) (not (= #b000000 U3_RS4_qk)) (= #b1 U3_RS4_qk_ROB_done)) U3_RS4_qk_update U3_RS_qk))
				(U3_LSQ_vj (ite (and (= #b1 U3_LSQ4_busy) (not (= #b000000 U3_LSQ4_qj)) (= #b1 U3_LSQ4_qj_ROB_done)) U3_LSQ4_vj_update U3_LSQ_vj))
				(U3_LSQ_vk (ite (and (= #b1 U3_LSQ4_busy) (not (= #b000000 U3_LSQ4_qk)) (= #b1 U3_LSQ4_qk_ROB_done)) U3_LSQ4_vk_update U3_LSQ_vk))
				(U3_LSQ_qj (ite (and (= #b1 U3_LSQ4_busy) (not (= #b000000 U3_LSQ4_qj)) (= #b1 U3_LSQ4_qj_ROB_done)) U3_LSQ4_qj_update U3_LSQ_qj))
				(U3_LSQ_qk (ite (and (= #b1 U3_LSQ4_busy) (not (= #b000000 U3_LSQ4_qk)) (= #b1 U3_LSQ4_qk_ROB_done)) U3_LSQ4_qk_update U3_LSQ_qk))
			)
		(let
			(
				(U3_RS5_vj_update (store U3_RS_vj (_ bv5 3) U3_RS5_qj_ROB_result))	
				(U3_RS5_vk_update (store U3_RS_vk (_ bv5 3) U3_RS5_qk_ROB_result))	
				(U3_RS5_qj_update (store U3_RS_qj (_ bv5 3) (_ bv0 6)))	
				(U3_RS5_qk_update (store U3_RS_qk (_ bv5 3) (_ bv0 6)))	
				(U3_LSQ5_vj_update (store U3_LSQ_vj (_ bv5 4) U3_LSQ5_qj_ROB_result))	
				(U3_LSQ5_vk_update (store U3_LSQ_vk (_ bv5 4) U3_LSQ5_qk_ROB_result))	
				(U3_LSQ5_qj_update (store U3_LSQ_qj (_ bv5 4) (_ bv0 6)))	
				(U3_LSQ5_qk_update (store U3_LSQ_qk (_ bv5 4) (_ bv0 6)))	
			)
		(let
			(
				(U3_RS_vj (ite (and (= #b1 U3_RS5_busy) (not (= #b000000 U3_RS5_qj)) (= #b1 U3_RS5_qj_ROB_done)) U3_RS5_vj_update U3_RS_vj))
				(U3_RS_vk (ite (and (= #b1 U3_RS5_busy) (not (= #b000000 U3_RS5_qk)) (= #b1 U3_RS5_qk_ROB_done)) U3_RS5_vk_update U3_RS_vk))
				(U3_RS_qj (ite (and (= #b1 U3_RS5_busy) (not (= #b000000 U3_RS5_qj)) (= #b1 U3_RS5_qj_ROB_done)) U3_RS5_qj_update U3_RS_qj))
				(U3_RS_qk (ite (and (= #b1 U3_RS5_busy) (not (= #b000000 U3_RS5_qk)) (= #b1 U3_RS5_qk_ROB_done)) U3_RS5_qk_update U3_RS_qk))
				(U3_LSQ_vj (ite (and (= #b1 U3_LSQ5_busy) (not (= #b000000 U3_LSQ5_qj)) (= #b1 U3_LSQ5_qj_ROB_done)) U3_LSQ5_vj_update U3_LSQ_vj))
				(U3_LSQ_vk (ite (and (= #b1 U3_LSQ5_busy) (not (= #b000000 U3_LSQ5_qk)) (= #b1 U3_LSQ5_qk_ROB_done)) U3_LSQ5_vk_update U3_LSQ_vk))
				(U3_LSQ_qj (ite (and (= #b1 U3_LSQ5_busy) (not (= #b000000 U3_LSQ5_qj)) (= #b1 U3_LSQ5_qj_ROB_done)) U3_LSQ5_qj_update U3_LSQ_qj))
				(U3_LSQ_qk (ite (and (= #b1 U3_LSQ5_busy) (not (= #b000000 U3_LSQ5_qk)) (= #b1 U3_LSQ5_qk_ROB_done)) U3_LSQ5_qk_update U3_LSQ_qk))
			)
		(let
			(
				(U3_RS6_vj_update (store U3_RS_vj (_ bv6 3) U3_RS6_qj_ROB_result))	
				(U3_RS6_vk_update (store U3_RS_vk (_ bv6 3) U3_RS6_qk_ROB_result))	
				(U3_RS6_qj_update (store U3_RS_qj (_ bv6 3) (_ bv0 6)))	
				(U3_RS6_qk_update (store U3_RS_qk (_ bv6 3) (_ bv0 6)))	
				(U3_LSQ6_vj_update (store U3_LSQ_vj (_ bv6 4) U3_LSQ6_qj_ROB_result))	
				(U3_LSQ6_vk_update (store U3_LSQ_vk (_ bv6 4) U3_LSQ6_qk_ROB_result))	
				(U3_LSQ6_qj_update (store U3_LSQ_qj (_ bv6 4) (_ bv0 6)))	
				(U3_LSQ6_qk_update (store U3_LSQ_qk (_ bv6 4) (_ bv0 6)))	
			)
		(let
			(
				(U3_RS_vj (ite (and (= #b1 U3_RS6_busy) (not (= #b000000 U3_RS6_qj)) (= #b1 U3_RS6_qj_ROB_done)) U3_RS6_vj_update U3_RS_vj))
				(U3_RS_vk (ite (and (= #b1 U3_RS6_busy) (not (= #b000000 U3_RS6_qk)) (= #b1 U3_RS6_qk_ROB_done)) U3_RS6_vk_update U3_RS_vk))
				(U3_RS_qj (ite (and (= #b1 U3_RS6_busy) (not (= #b000000 U3_RS6_qj)) (= #b1 U3_RS6_qj_ROB_done)) U3_RS6_qj_update U3_RS_qj))
				(U3_RS_qk (ite (and (= #b1 U3_RS6_busy) (not (= #b000000 U3_RS6_qk)) (= #b1 U3_RS6_qk_ROB_done)) U3_RS6_qk_update U3_RS_qk))
				(U3_LSQ_vj (ite (and (= #b1 U3_LSQ6_busy) (not (= #b000000 U3_LSQ6_qj)) (= #b1 U3_LSQ6_qj_ROB_done)) U3_LSQ6_vj_update U3_LSQ_vj))
				(U3_LSQ_vk (ite (and (= #b1 U3_LSQ6_busy) (not (= #b000000 U3_LSQ6_qk)) (= #b1 U3_LSQ6_qk_ROB_done)) U3_LSQ6_vk_update U3_LSQ_vk))
				(U3_LSQ_qj (ite (and (= #b1 U3_LSQ6_busy) (not (= #b000000 U3_LSQ6_qj)) (= #b1 U3_LSQ6_qj_ROB_done)) U3_LSQ6_qj_update U3_LSQ_qj))
				(U3_LSQ_qk (ite (and (= #b1 U3_LSQ6_busy) (not (= #b000000 U3_LSQ6_qk)) (= #b1 U3_LSQ6_qk_ROB_done)) U3_LSQ6_qk_update U3_LSQ_qk))
			)
		(let
			(
				(U3_RS7_vj_update (store U3_RS_vj (_ bv7 3) U3_RS7_qj_ROB_result))	
				(U3_RS7_vk_update (store U3_RS_vk (_ bv7 3) U3_RS7_qk_ROB_result))	
				(U3_RS7_qj_update (store U3_RS_qj (_ bv7 3) (_ bv0 6)))	
				(U3_RS7_qk_update (store U3_RS_qk (_ bv7 3) (_ bv0 6)))	
				(U3_LSQ7_vj_update (store U3_LSQ_vj (_ bv7 4) U3_LSQ7_qj_ROB_result))	
				(U3_LSQ7_vk_update (store U3_LSQ_vk (_ bv7 4) U3_LSQ7_qk_ROB_result))	
				(U3_LSQ7_qj_update (store U3_LSQ_qj (_ bv7 4) (_ bv0 6)))	
				(U3_LSQ7_qk_update (store U3_LSQ_qk (_ bv7 4) (_ bv0 6)))	
			)
		(let
			(
				(U3_RS_vj (ite (and (= #b1 U3_RS7_busy) (not (= #b000000 U3_RS7_qj)) (= #b1 U3_RS7_qj_ROB_done)) U3_RS7_vj_update U3_RS_vj))
				(U3_RS_vk (ite (and (= #b1 U3_RS7_busy) (not (= #b000000 U3_RS7_qk)) (= #b1 U3_RS7_qk_ROB_done)) U3_RS7_vk_update U3_RS_vk))
				(U3_RS_qj (ite (and (= #b1 U3_RS7_busy) (not (= #b000000 U3_RS7_qj)) (= #b1 U3_RS7_qj_ROB_done)) U3_RS7_qj_update U3_RS_qj))
				(U3_RS_qk (ite (and (= #b1 U3_RS7_busy) (not (= #b000000 U3_RS7_qk)) (= #b1 U3_RS7_qk_ROB_done)) U3_RS7_qk_update U3_RS_qk))
				(U3_LSQ_vj (ite (and (= #b1 U3_LSQ7_busy) (not (= #b000000 U3_LSQ7_qj)) (= #b1 U3_LSQ7_qj_ROB_done)) U3_LSQ7_vj_update U3_LSQ_vj))
				(U3_LSQ_vk (ite (and (= #b1 U3_LSQ7_busy) (not (= #b000000 U3_LSQ7_qk)) (= #b1 U3_LSQ7_qk_ROB_done)) U3_LSQ7_vk_update U3_LSQ_vk))
				(U3_LSQ_qj (ite (and (= #b1 U3_LSQ7_busy) (not (= #b000000 U3_LSQ7_qj)) (= #b1 U3_LSQ7_qj_ROB_done)) U3_LSQ7_qj_update U3_LSQ_qj))
				(U3_LSQ_qk (ite (and (= #b1 U3_LSQ7_busy) (not (= #b000000 U3_LSQ7_qk)) (= #b1 U3_LSQ7_qk_ROB_done)) U3_LSQ7_qk_update U3_LSQ_qk))
			)

			(let
			(

				(U3_LSQ8_vj_update (store U3_LSQ_vj (_ bv8 4) U3_LSQ8_qj_ROB_result))	
				(U3_LSQ8_vk_update (store U3_LSQ_vk (_ bv8 4) U3_LSQ8_qk_ROB_result))	
				(U3_LSQ8_qj_update (store U3_LSQ_qj (_ bv8 4) (_ bv0 6)))	
				(U3_LSQ8_qk_update (store U3_LSQ_qk (_ bv8 4) (_ bv0 6)))	
			)
		(let
			(
				(U3_LSQ_vj (ite (and (= #b1 U3_LSQ8_busy) (not (= #b000000 U3_LSQ8_qj)) (= #b1 U3_LSQ8_qj_ROB_done)) U3_LSQ8_vj_update U3_LSQ_vj))
				(U3_LSQ_vk (ite (and (= #b1 U3_LSQ8_busy) (not (= #b000000 U3_LSQ8_qk)) (= #b1 U3_LSQ8_qk_ROB_done)) U3_LSQ8_vk_update U3_LSQ_vk))
				(U3_LSQ_qj (ite (and (= #b1 U3_LSQ8_busy) (not (= #b000000 U3_LSQ8_qj)) (= #b1 U3_LSQ8_qj_ROB_done)) U3_LSQ8_qj_update U3_LSQ_qj))
				(U3_LSQ_qk (ite (and (= #b1 U3_LSQ8_busy) (not (= #b000000 U3_LSQ8_qk)) (= #b1 U3_LSQ8_qk_ROB_done)) U3_LSQ8_qk_update U3_LSQ_qk))
			)

        (let
			(
	
				(U3_LSQ9_vj_update (store U3_LSQ_vj (_ bv9 4) U3_LSQ9_qj_ROB_result))	
				(U3_LSQ9_vk_update (store U3_LSQ_vk (_ bv9 4) U3_LSQ9_qk_ROB_result))	
				(U3_LSQ9_qj_update (store U3_LSQ_qj (_ bv9 4) (_ bv0 6)))	
				(U3_LSQ9_qk_update (store U3_LSQ_qk (_ bv9 4) (_ bv0 6)))	
			)
		(let
			(
				(U3_LSQ_vj (ite (and (= #b1 U3_LSQ9_busy) (not (= #b000000 U3_LSQ9_qj)) (= #b1 U3_LSQ9_qj_ROB_done)) U3_LSQ9_vj_update U3_LSQ_vj))
				(U3_LSQ_vk (ite (and (= #b1 U3_LSQ9_busy) (not (= #b000000 U3_LSQ9_qk)) (= #b1 U3_LSQ9_qk_ROB_done)) U3_LSQ9_vk_update U3_LSQ_vk))
				(U3_LSQ_qj (ite (and (= #b1 U3_LSQ9_busy) (not (= #b000000 U3_LSQ9_qj)) (= #b1 U3_LSQ9_qj_ROB_done)) U3_LSQ9_qj_update U3_LSQ_qj))
				(U3_LSQ_qk (ite (and (= #b1 U3_LSQ9_busy) (not (= #b000000 U3_LSQ9_qk)) (= #b1 U3_LSQ9_qk_ROB_done)) U3_LSQ9_qk_update U3_LSQ_qk))
			)

       (let
			(	
				(U3_LSQ10_vj_update (store U3_LSQ_vj (_ bv10 4) U3_LSQ10_qj_ROB_result))	
				(U3_LSQ10_vk_update (store U3_LSQ_vk (_ bv10 4) U3_LSQ10_qk_ROB_result))	
				(U3_LSQ10_qj_update (store U3_LSQ_qj (_ bv10 4) (_ bv0 6)))	
				(U3_LSQ10_qk_update (store U3_LSQ_qk (_ bv10 4) (_ bv0 6)))	
			)
		(let
			(
				(U3_LSQ_vj (ite (and (= #b1 U3_LSQ10_busy) (not (= #b000000 U3_LSQ10_qj)) (= #b1 U3_LSQ10_qj_ROB_done)) U3_LSQ10_vj_update U3_LSQ_vj))
				(U3_LSQ_vk (ite (and (= #b1 U3_LSQ10_busy) (not (= #b000000 U3_LSQ10_qk)) (= #b1 U3_LSQ10_qk_ROB_done)) U3_LSQ10_vk_update U3_LSQ_vk))
				(U3_LSQ_qj (ite (and (= #b1 U3_LSQ10_busy) (not (= #b000000 U3_LSQ10_qj)) (= #b1 U3_LSQ10_qj_ROB_done)) U3_LSQ10_qj_update U3_LSQ_qj))
				(U3_LSQ_qk (ite (and (= #b1 U3_LSQ10_busy) (not (= #b000000 U3_LSQ10_qk)) (= #b1 U3_LSQ10_qk_ROB_done)) U3_LSQ10_qk_update U3_LSQ_qk))
			)

		(let
			(	
				(U3_LSQ11_vj_update (store U3_LSQ_vj (_ bv11 4) U3_LSQ11_qj_ROB_result))	
				(U3_LSQ11_vk_update (store U3_LSQ_vk (_ bv11 4) U3_LSQ11_qk_ROB_result))	
				(U3_LSQ11_qj_update (store U3_LSQ_qj (_ bv11 4) (_ bv0 6)))	
				(U3_LSQ11_qk_update (store U3_LSQ_qk (_ bv11 4) (_ bv0 6)))	
			)
		(let
			(
				(U3_LSQ_vj (ite (and (= #b1 U3_LSQ11_busy) (not (= #b000000 U3_LSQ11_qj)) (= #b1 U3_LSQ11_qj_ROB_done)) U3_LSQ11_vj_update U3_LSQ_vj))
				(U3_LSQ_vk (ite (and (= #b1 U3_LSQ11_busy) (not (= #b000000 U3_LSQ11_qk)) (= #b1 U3_LSQ11_qk_ROB_done)) U3_LSQ11_vk_update U3_LSQ_vk))
				(U3_LSQ_qj (ite (and (= #b1 U3_LSQ11_busy) (not (= #b000000 U3_LSQ11_qj)) (= #b1 U3_LSQ11_qj_ROB_done)) U3_LSQ11_qj_update U3_LSQ_qj))
				(U3_LSQ_qk (ite (and (= #b1 U3_LSQ11_busy) (not (= #b000000 U3_LSQ11_qk)) (= #b1 U3_LSQ11_qk_ROB_done)) U3_LSQ11_qk_update U3_LSQ_qk))
			)
        (let
			(	
				(U3_LSQ12_vj_update (store U3_LSQ_vj (_ bv12 4) U3_LSQ12_qj_ROB_result))	
				(U3_LSQ12_vk_update (store U3_LSQ_vk (_ bv12 4) U3_LSQ12_qk_ROB_result))	
				(U3_LSQ12_qj_update (store U3_LSQ_qj (_ bv12 4) (_ bv0 6)))	
				(U3_LSQ12_qk_update (store U3_LSQ_qk (_ bv12 4) (_ bv0 6)))	
			)
		(let
			(
				(U3_LSQ_vj (ite (and (= #b1 U3_LSQ12_busy) (not (= #b000000 U3_LSQ12_qj)) (= #b1 U3_LSQ12_qj_ROB_done)) U3_LSQ12_vj_update U3_LSQ_vj))
				(U3_LSQ_vk (ite (and (= #b1 U3_LSQ12_busy) (not (= #b000000 U3_LSQ12_qk)) (= #b1 U3_LSQ12_qk_ROB_done)) U3_LSQ12_vk_update U3_LSQ_vk))
				(U3_LSQ_qj (ite (and (= #b1 U3_LSQ12_busy) (not (= #b000000 U3_LSQ12_qj)) (= #b1 U3_LSQ12_qj_ROB_done)) U3_LSQ12_qj_update U3_LSQ_qj))
				(U3_LSQ_qk (ite (and (= #b1 U3_LSQ12_busy) (not (= #b000000 U3_LSQ12_qk)) (= #b1 U3_LSQ12_qk_ROB_done)) U3_LSQ12_qk_update U3_LSQ_qk))
			)

		(let
			(	
				(U3_LSQ13_vj_update (store U3_LSQ_vj (_ bv13 4) U3_LSQ13_qj_ROB_result))	
				(U3_LSQ13_vk_update (store U3_LSQ_vk (_ bv13 4) U3_LSQ13_qk_ROB_result))	
				(U3_LSQ13_qj_update (store U3_LSQ_qj (_ bv13 4) (_ bv0 6)))	
				(U3_LSQ13_qk_update (store U3_LSQ_qk (_ bv13 4) (_ bv0 6)))	
			)
		(let
			(
				(U3_LSQ_vj (ite (and (= #b1 U3_LSQ13_busy) (not (= #b000000 U3_LSQ13_qj)) (= #b1 U3_LSQ13_qj_ROB_done)) U3_LSQ13_vj_update U3_LSQ_vj))
				(U3_LSQ_vk (ite (and (= #b1 U3_LSQ13_busy) (not (= #b000000 U3_LSQ13_qk)) (= #b1 U3_LSQ13_qk_ROB_done)) U3_LSQ13_vk_update U3_LSQ_vk))
				(U3_LSQ_qj (ite (and (= #b1 U3_LSQ13_busy) (not (= #b000000 U3_LSQ13_qj)) (= #b1 U3_LSQ13_qj_ROB_done)) U3_LSQ13_qj_update U3_LSQ_qj))
				(U3_LSQ_qk (ite (and (= #b1 U3_LSQ13_busy) (not (= #b000000 U3_LSQ13_qk)) (= #b1 U3_LSQ13_qk_ROB_done)) U3_LSQ13_qk_update U3_LSQ_qk))
			)

			(let
			(	
				(U3_LSQ14_vj_update (store U3_LSQ_vj (_ bv14 4) U3_LSQ14_qj_ROB_result))	
				(U3_LSQ14_vk_update (store U3_LSQ_vk (_ bv14 4) U3_LSQ14_qk_ROB_result))	
				(U3_LSQ14_qj_update (store U3_LSQ_qj (_ bv14 4) (_ bv0 6)))	
				(U3_LSQ14_qk_update (store U3_LSQ_qk (_ bv14 4) (_ bv0 6)))	
			)
		(let
			(
				(U3_LSQ_vj (ite (and (= #b1 U3_LSQ14_busy) (not (= #b000000 U3_LSQ14_qj)) (= #b1 U3_LSQ14_qj_ROB_done)) U3_LSQ14_vj_update U3_LSQ_vj))
				(U3_LSQ_vk (ite (and (= #b1 U3_LSQ14_busy) (not (= #b000000 U3_LSQ14_qk)) (= #b1 U3_LSQ14_qk_ROB_done)) U3_LSQ14_vk_update U3_LSQ_vk))
				(U3_LSQ_qj (ite (and (= #b1 U3_LSQ14_busy) (not (= #b000000 U3_LSQ14_qj)) (= #b1 U3_LSQ14_qj_ROB_done)) U3_LSQ14_qj_update U3_LSQ_qj))
				(U3_LSQ_qk (ite (and (= #b1 U3_LSQ14_busy) (not (= #b000000 U3_LSQ14_qk)) (= #b1 U3_LSQ14_qk_ROB_done)) U3_LSQ14_qk_update U3_LSQ_qk))
			)
        (let
			(	
				(U3_LSQ15_vj_update (store U3_LSQ_vj (_ bv15 4) U3_LSQ15_qj_ROB_result))	
				(U3_LSQ15_vk_update (store U3_LSQ_vk (_ bv15 4) U3_LSQ15_qk_ROB_result))	
				(U3_LSQ15_qj_update (store U3_LSQ_qj (_ bv15 4) (_ bv0 6)))	
				(U3_LSQ15_qk_update (store U3_LSQ_qk (_ bv15 4) (_ bv0 6)))	
			)
		(let
			(
				(U3_LSQ_vj (ite (and (= #b1 U3_LSQ15_busy) (not (= #b000000 U3_LSQ15_qj)) (= #b1 U3_LSQ15_qj_ROB_done)) U3_LSQ15_vj_update U3_LSQ_vj))
				(U3_LSQ_vk (ite (and (= #b1 U3_LSQ15_busy) (not (= #b000000 U3_LSQ15_qk)) (= #b1 U3_LSQ15_qk_ROB_done)) U3_LSQ15_vk_update U3_LSQ_vk))
				(U3_LSQ_qj (ite (and (= #b1 U3_LSQ15_busy) (not (= #b000000 U3_LSQ15_qj)) (= #b1 U3_LSQ15_qj_ROB_done)) U3_LSQ15_qj_update U3_LSQ_qj))
				(U3_LSQ_qk (ite (and (= #b1 U3_LSQ15_busy) (not (= #b000000 U3_LSQ15_qk)) (= #b1 U3_LSQ15_qk_ROB_done)) U3_LSQ15_qk_update U3_LSQ_qk))
			)



		;-- Get all the tag values, generate and store the new dispatch bit values	
		(let
			(
				(U3_RS0_busy (select U3_RS_busy (_ bv0 3)))
				(U3_RS0_qj (select U3_RS_qj (_ bv0 3)))
				(U3_RS0_qk (select U3_RS_qk (_ bv0 3)))
				(U3_RS1_busy (select U3_RS_busy (_ bv1 3)))
				(U3_RS1_qj (select U3_RS_qj (_ bv1 3)))
				(U3_RS1_qk (select U3_RS_qk (_ bv1 3)))
				(U3_RS2_busy (select U3_RS_busy (_ bv2 3)))
				(U3_RS2_qj (select U3_RS_qj (_ bv2 3)))
				(U3_RS2_qk (select U3_RS_qk (_ bv2 3)))
				(U3_RS3_busy (select U3_RS_busy (_ bv3 3)))
				(U3_RS3_qj (select U3_RS_qj (_ bv3 3)))
				(U3_RS3_qk (select U3_RS_qk (_ bv3 3)))
				(U3_RS4_busy (select U3_RS_busy (_ bv4 3)))
				(U3_RS4_qj (select U3_RS_qj (_ bv4 3)))
				(U3_RS4_qk (select U3_RS_qk (_ bv4 3)))
				(U3_RS5_busy (select U3_RS_busy (_ bv5 3)))
				(U3_RS5_qj (select U3_RS_qj (_ bv5 3)))
				(U3_RS5_qk (select U3_RS_qk (_ bv5 3)))
				(U3_RS6_busy (select U3_RS_busy (_ bv6 3)))
				(U3_RS6_qj (select U3_RS_qj (_ bv6 3)))
				(U3_RS6_qk (select U3_RS_qk (_ bv6 3)))
				(U3_RS7_busy (select U3_RS_busy (_ bv7 3)))
				(U3_RS7_qj (select U3_RS_qj (_ bv7 3)))
				(U3_RS7_qk (select U3_RS_qk (_ bv7 3)))


				(U3_LSQ0_busy (select U3_LSQ_busy (_ bv0 4)))
				(U3_LSQ0_qj (select U3_LSQ_qj (_ bv0 4)))
				(U3_LSQ0_qk (select U3_LSQ_qk (_ bv0 4)))
				(U3_LSQ1_busy (select U3_LSQ_busy (_ bv1 4)))
				(U3_LSQ1_qj (select U3_LSQ_qj (_ bv1 4)))
				(U3_LSQ1_qk (select U3_LSQ_qk (_ bv1 4)))
				(U3_LSQ2_busy (select U3_LSQ_busy (_ bv2 4)))
				(U3_LSQ2_qj (select U3_LSQ_qj (_ bv2 4)))
				(U3_LSQ2_qk (select U3_LSQ_qk (_ bv2 4)))
				(U3_LSQ3_busy (select U3_LSQ_busy (_ bv3 4)))
				(U3_LSQ3_qj (select U3_LSQ_qj (_ bv3 4)))
				(U3_LSQ3_qk (select U3_LSQ_qk (_ bv3 4)))
				(U3_LSQ4_busy (select U3_LSQ_busy (_ bv4 4)))
				(U3_LSQ4_qj (select U3_LSQ_qj (_ bv4 4)))
				(U3_LSQ4_qk (select U3_LSQ_qk (_ bv4 4)))
				(U3_LSQ5_busy (select U3_LSQ_busy (_ bv5 4)))
				(U3_LSQ5_qj (select U3_LSQ_qj (_ bv5 4)))
				(U3_LSQ5_qk (select U3_LSQ_qk (_ bv5 4)))
				(U3_LSQ6_busy (select U3_LSQ_busy (_ bv6 4)))
				(U3_LSQ6_qj (select U3_LSQ_qj (_ bv6 4)))
				(U3_LSQ6_qk (select U3_LSQ_qk (_ bv6 4)))
				(U3_LSQ7_busy (select U3_LSQ_busy (_ bv7 4)))
				(U3_LSQ7_qj (select U3_LSQ_qj (_ bv7 4)))
				(U3_LSQ7_qk (select U3_LSQ_qk (_ bv7 4)))
				(U3_LSQ8_busy (select U3_LSQ_busy (_ bv8 4)))
				(U3_LSQ8_qj (select U3_LSQ_qj (_ bv8 4)))
				(U3_LSQ8_qk (select U3_LSQ_qk (_ bv8 4)))
				(U3_LSQ9_busy (select U3_LSQ_busy (_ bv9 4)))
				(U3_LSQ9_qj (select U3_LSQ_qj (_ bv9 4)))
				(U3_LSQ9_qk (select U3_LSQ_qk (_ bv9 4)))
				(U3_LSQ10_busy (select U3_LSQ_busy (_ bv10 4)))
				(U3_LSQ10_qj (select U3_LSQ_qj (_ bv10 4)))
				(U3_LSQ10_qk (select U3_LSQ_qk (_ bv10 4)))
				(U3_LSQ11_busy (select U3_LSQ_busy (_ bv11 4)))
				(U3_LSQ11_qj (select U3_LSQ_qj (_ bv11 4)))
				(U3_LSQ11_qk (select U3_LSQ_qk (_ bv11 4)))
				(U3_LSQ12_busy (select U3_LSQ_busy (_ bv12 4)))
				(U3_LSQ12_qj (select U3_LSQ_qj (_ bv12 4)))
				(U3_LSQ12_qk (select U3_LSQ_qk (_ bv12 4)))
				(U3_LSQ13_busy (select U3_LSQ_busy (_ bv13 4)))
				(U3_LSQ13_qj (select U3_LSQ_qj (_ bv13 4)))
				(U3_LSQ13_qk (select U3_LSQ_qk (_ bv13 4)))
				(U3_LSQ14_busy (select U3_LSQ_busy (_ bv14 4)))
				(U3_LSQ14_qj (select U3_LSQ_qj (_ bv14 4)))
				(U3_LSQ14_qk (select U3_LSQ_qk (_ bv14 4)))
				(U3_LSQ15_busy (select U3_LSQ_busy (_ bv15 4)))
				(U3_LSQ15_qj (select U3_LSQ_qj (_ bv15 4)))
				(U3_LSQ15_qk (select U3_LSQ_qk (_ bv15 4)))
			)	
		(let
			(
				(U3_RS0_dis (ite (and (= #b1 U3_RS0_busy) (= #b000000 U3_RS0_qj) (= #b000000 U3_RS0_qk)) (_ bv1 1) (_ bv0 1)))
				(U3_RS1_dis (ite (and (= #b1 U3_RS1_busy) (= #b000000 U3_RS1_qj) (= #b000000 U3_RS1_qk)) (_ bv1 1) (_ bv0 1)))
				(U3_RS2_dis (ite (and (= #b1 U3_RS2_busy) (= #b000000 U3_RS2_qj) (= #b000000 U3_RS2_qk)) (_ bv1 1) (_ bv0 1)))
				(U3_RS3_dis (ite (and (= #b1 U3_RS3_busy) (= #b000000 U3_RS3_qj) (= #b000000 U3_RS3_qk)) (_ bv1 1) (_ bv0 1)))	
				(U3_RS4_dis (ite (and (= #b1 U3_RS4_busy) (= #b000000 U3_RS4_qj) (= #b000000 U3_RS4_qk)) (_ bv1 1) (_ bv0 1)))	
				(U3_RS5_dis (ite (and (= #b1 U3_RS5_busy) (= #b000000 U3_RS5_qj) (= #b000000 U3_RS5_qk)) (_ bv1 1) (_ bv0 1)))	
				(U3_RS6_dis (ite (and (= #b1 U3_RS6_busy) (= #b000000 U3_RS6_qj) (= #b000000 U3_RS6_qk)) (_ bv1 1) (_ bv0 1)))	
				(U3_RS7_dis (ite (and (= #b1 U3_RS7_busy) (= #b000000 U3_RS7_qj) (= #b000000 U3_RS7_qk)) (_ bv1 1) (_ bv0 1)))	
				
				(U3_LSQ0_dis (ite (and (= #b1 U3_LSQ0_busy) (= #b000000 U3_LSQ0_qj) (= #b000000 U3_LSQ0_qk)) (_ bv1 1) (_ bv0 1)))
				(U3_LSQ1_dis (ite (and (= #b1 U3_LSQ1_busy) (= #b000000 U3_LSQ1_qj) (= #b000000 U3_LSQ1_qk)) (_ bv1 1) (_ bv0 1)))
				(U3_LSQ2_dis (ite (and (= #b1 U3_LSQ2_busy) (= #b000000 U3_LSQ2_qj) (= #b000000 U3_LSQ2_qk)) (_ bv1 1) (_ bv0 1)))
				(U3_LSQ3_dis (ite (and (= #b1 U3_LSQ3_busy) (= #b000000 U3_LSQ3_qj) (= #b000000 U3_LSQ3_qk)) (_ bv1 1) (_ bv0 1)))
				(U3_LSQ4_dis (ite (and (= #b1 U3_LSQ4_busy) (= #b000000 U3_LSQ4_qj) (= #b000000 U3_LSQ4_qk)) (_ bv1 1) (_ bv0 1)))
				(U3_LSQ5_dis (ite (and (= #b1 U3_LSQ5_busy) (= #b000000 U3_LSQ5_qj) (= #b000000 U3_LSQ5_qk)) (_ bv1 1) (_ bv0 1)))
				(U3_LSQ6_dis (ite (and (= #b1 U3_LSQ6_busy) (= #b000000 U3_LSQ6_qj) (= #b000000 U3_LSQ6_qk)) (_ bv1 1) (_ bv0 1)))
				(U3_LSQ7_dis (ite (and (= #b1 U3_LSQ7_busy) (= #b000000 U3_LSQ7_qj) (= #b000000 U3_LSQ7_qk)) (_ bv1 1) (_ bv0 1)))
				(U3_LSQ8_dis (ite (and (= #b1 U3_LSQ8_busy) (= #b000000 U3_LSQ8_qj) (= #b000000 U3_LSQ8_qk)) (_ bv1 1) (_ bv0 1)))
				(U3_LSQ9_dis (ite (and (= #b1 U3_LSQ9_busy) (= #b000000 U3_LSQ9_qj) (= #b000000 U3_LSQ9_qk)) (_ bv1 1) (_ bv0 1)))
				(U3_LSQ10_dis (ite (and (= #b1 U3_LSQ10_busy) (= #b000000 U3_LSQ10_qj) (= #b000000 U3_LSQ10_qk)) (_ bv1 1) (_ bv0 1)))
				(U3_LSQ11_dis (ite (and (= #b1 U3_LSQ11_busy) (= #b000000 U3_LSQ11_qj) (= #b000000 U3_LSQ11_qk)) (_ bv1 1) (_ bv0 1)))
				(U3_LSQ12_dis (ite (and (= #b1 U3_LSQ12_busy) (= #b000000 U3_LSQ12_qj) (= #b000000 U3_LSQ12_qk)) (_ bv1 1) (_ bv0 1)))
				(U3_LSQ13_dis (ite (and (= #b1 U3_LSQ13_busy) (= #b000000 U3_LSQ13_qj) (= #b000000 U3_LSQ13_qk)) (_ bv1 1) (_ bv0 1)))
				(U3_LSQ14_dis (ite (and (= #b1 U3_LSQ14_busy) (= #b000000 U3_LSQ14_qj) (= #b000000 U3_LSQ14_qk)) (_ bv1 1) (_ bv0 1)))
				(U3_LSQ15_dis (ite (and (= #b1 U3_LSQ15_busy) (= #b000000 U3_LSQ15_qj) (= #b000000 U3_LSQ15_qk)) (_ bv1 1) (_ bv0 1)))
			)			
		(let
            (
				(U3_RS_dis (store U3_RS_dis (_ bv0 3) U3_RS0_dis))
				(U3_LSQ_dis (store U3_LSQ_dis (_ bv0 4) U3_LSQ0_dis))
			)
		(let
			(
				(U3_RS_dis (store U3_RS_dis (_ bv1 3) U3_RS1_dis))
				(U3_LSQ_dis (store U3_LSQ_dis (_ bv1 4) U3_LSQ1_dis))
			)
		(let
			(
				(U3_RS_dis (store U3_RS_dis (_ bv2 3) U3_RS2_dis))
				(U3_LSQ_dis (store U3_LSQ_dis (_ bv2 4) U3_LSQ2_dis))
			)
		(let
			(
				(U3_RS_dis (store U3_RS_dis (_ bv3 3) U3_RS3_dis))
				(U3_LSQ_dis (store U3_LSQ_dis (_ bv3 4) U3_LSQ3_dis))
			)	
        (let
			(
				(U3_RS_dis (store U3_RS_dis (_ bv4 3) U3_RS4_dis))
				(U3_LSQ_dis (store U3_LSQ_dis (_ bv4 4) U3_LSQ4_dis))
			)
		(let
			(
				(U3_RS_dis (store U3_RS_dis (_ bv5 3) U3_RS5_dis))
				(U3_LSQ_dis (store U3_LSQ_dis (_ bv5 4) U3_LSQ5_dis))
			)
		(let
			(
				(U3_RS_dis (store U3_RS_dis (_ bv6 3) U3_RS6_dis))
				(U3_LSQ_dis (store U3_LSQ_dis (_ bv6 4) U3_LSQ6_dis))
			)
		(let
			(
				(U3_RS_dis (store U3_RS_dis (_ bv7 3) U3_RS7_dis))
				(U3_LSQ_dis (store U3_LSQ_dis (_ bv7 4) U3_LSQ7_dis))
			)
		(let
			(
				(U3_LSQ_dis (store U3_LSQ_dis (_ bv8 4) U3_LSQ8_dis))
			)
		(let
			(
				(U3_LSQ_dis (store U3_LSQ_dis (_ bv9 4) U3_LSQ9_dis))
			)
		(let
			(
				(U3_LSQ_dis (store U3_LSQ_dis (_ bv10 4) U3_LSQ10_dis))
			)
		(let
			(
				(U3_LSQ_dis (store U3_LSQ_dis (_ bv11 4) U3_LSQ11_dis))
			)	
        (let
            (
				(U3_LSQ_dis (store U3_LSQ_dis (_ bv12 4) U3_LSQ12_dis))
			)
		(let
			(
				(U3_LSQ_dis (store U3_LSQ_dis (_ bv13 4) U3_LSQ13_dis))
			)
		(let
			(
				(U3_LSQ_dis (store U3_LSQ_dis (_ bv14 4) U3_LSQ14_dis))
            )
		(let
			(	
				(U3_LSQ_dis (store U3_LSQ_dis (_ bv15 4) U3_LSQ15_dis))
			)
		;-- Transistion everything to next state (U3)
		(let
			(
				(U3_RF (ite (= 0 0) U2_RF U2_RF))
				(U3_DM (ite (= 0 0) U2_DM U2_DM))
				
				(U3_CacheL1_Tag (ite (= 0 0) U3_CacheL1_Tag U3_CacheL1_Tag))
				(U3_CacheL1_Data (ite (= 0 0) U3_CacheL1_Data U3_CacheL1_Data))
				(U3_CacheL1_Valid (ite (= 0 0) U3_CacheL1_Valid U3_CacheL1_Valid))
				
				(U3_PC (ite (= 0 0) U2_PC U2_PC))
				
				(U3_IP (ite (= 0 0) U2_IP U2_IP))
				(U3_CP (ite (= 0 0) U2_CP U2_CP))
				
				(U3_ROB_busy (ite (= 0 0) U2_ROB_busy U2_ROB_busy))
				(U3_ROB_op (ite (= 0 0) U2_ROB_op U2_ROB_op))
				(U3_ROB_destination (ite (= 0 0) U3_ROB_destination U3_ROB_destination))
				(U3_ROB_result (ite (= 0 0) U3_ROB_result U3_ROB_result))
				(U3_ROB_exception (ite (= 0 0) U3_ROB_exception U3_ROB_exception))
				(U3_ROB_done (ite (= 0 0) U3_ROB_done U3_ROB_done))
				
				(U3_ROB_Maddress (ite (= 0 0) U3_ROB_Maddress U3_ROB_Maddress))
				
				(U3_RS_op (ite (= 0 0) U3_RS_op U3_RS_op))
				(U3_RS_ROB_dst (ite (= 0 0) U3_RS_ROB_dst U3_RS_ROB_dst))
				(U3_RS_vj (ite (= 0 0) U3_RS_vj U3_RS_vj))
				(U3_RS_vk (ite (= 0 0) U3_RS_vk U3_RS_vk))
				(U3_RS_qj (ite (= 0 0) U3_RS_qj U3_RS_qj))
				(U3_RS_qk (ite (= 0 0) U3_RS_qk U3_RS_qk))
				(U3_RS_imm (ite (= 0 0) U3_RS_imm U3_RS_imm))
				(U3_RS_dis (ite (= 0 0) U3_RS_dis U3_RS_dis))
				(U3_RS_busy (ite (= 0 0) U3_RS_busy U3_RS_busy))
				
				(U3_LSQ_op (ite (= 0 0) U3_LSQ_op U3_LSQ_op))
				(U3_LSQ_ROB_dst (ite (= 0 0) U3_LSQ_ROB_dst U3_LSQ_ROB_dst))
				(U3_LSQ_vj (ite (= 0 0) U3_LSQ_vj U3_LSQ_vj))
				(U3_LSQ_vk (ite (= 0 0) U3_LSQ_vk U3_LSQ_vk))
				(U3_LSQ_qj (ite (= 0 0) U3_LSQ_qj U3_LSQ_qj))
				(U3_LSQ_qk (ite (= 0 0) U3_LSQ_qk U3_LSQ_qk))
				(U3_LSQ_imm (ite (= 0 0) U3_LSQ_imm U3_LSQ_imm))
				(U3_LSQ_dis (ite (= 0 0) U3_LSQ_dis U3_LSQ_dis))
				(U3_LSQ_busy (ite (= 0 0) U3_LSQ_busy U3_LSQ_busy))	
			)			
;---------------------------Commit-------------------------------------------------
		;-- Get information from the ROB entry pointed by the commit pointer (CP)
		(let
			(
				(CP_U3_ROB_busy (select U3_ROB_busy U3_CP))
				(CP_U3_ROB_op (select U3_ROB_op U3_CP))
				(CP_U3_ROB_destination (select U3_ROB_destination U3_CP))
				(CP_U3_ROB_result (select U3_ROB_result U3_CP))
				(CP_U3_ROB_exception (select U3_ROB_exception U3_CP))
				(CP_U3_ROB_done (select U3_ROB_done U3_CP))
				
				(CP_U3_ROB_Maddress (select U3_ROB_Maddress U3_CP))
				
				(CP_update (addition U3_CP ))	;-- Update the CP
			)			
		;-- store result into RF and DM using the destination address (Potential update step)
		;-- Clear the ROB entry that got commited (Potential)
		(let
			(
				(RF_update (store U3_RF CP_U3_ROB_destination CP_U3_ROB_result))

				(U3_ROB_busy_update (store U3_ROB_busy U3_CP (_ bv0 1)))
				(U3_ROB_op_update (store U3_ROB_op U3_CP 0))
				(U3_ROB_destination_update (store U3_ROB_destination U3_CP 0))
				(U3_ROB_result_update (store U3_ROB_result U3_CP 0))
				(U3_ROB_exception_update (store U3_ROB_exception U3_CP (_ bv0 1)))
				(U3_ROB_done_update (store U3_ROB_done U3_CP (_ bv0 1)))
				
				(U3_ROB_Maddress_update (store U3_ROB_Maddress U3_CP 0))
			)
		;-- Transition everything to next state (U4)
		(let
			(
				(U4_RF (ite (and (= CP_U3_ROB_done #b1) (or (= CP_U3_ROB_op Rtype) (= CP_U3_ROB_op SLoad))) RF_update U3_RF))
				
				(U4_DM (ite (= 0 0) U3_DM U3_DM))
				
				(U4_PC (ite (and (= CP_U3_ROB_done #b1) (= CP_U3_ROB_op Branch) (= CP_U3_ROB_exception #b1)) CP_U3_ROB_destination U3_PC))
				
				(U4_IP (ite (and (= CP_U3_ROB_done #b1) (= CP_U3_ROB_op Branch) (= CP_U3_ROB_exception #b1)) (_ bv1 6) U3_IP))
				(U4_CP 
					(ite (and (= CP_U3_ROB_done #b1) (= CP_U3_ROB_op Branch) (= CP_U3_ROB_exception #b1)) (_ bv1 6) 
					(ite (= CP_U3_ROB_done #b1) CP_update
					U3_CP))
				)
				(U4_ROB_busy 
					(ite (and (= CP_U3_ROB_done #b1) (= CP_U3_ROB_op Branch) (= CP_U3_ROB_exception #b1)) empty_ROB_1bit
					(ite (= CP_U3_ROB_done #b1) U3_ROB_busy_update
					U3_ROB_busy))
				)
				(U4_ROB_op
					(ite (and (= CP_U3_ROB_done #b1) (= CP_U3_ROB_op Branch) (= CP_U3_ROB_exception #b1)) empty_ROB_int
					(ite (= CP_U3_ROB_done #b1) U3_ROB_op_update
					U3_ROB_op))
				)
				(U4_ROB_destination 
					(ite (and (= CP_U3_ROB_done #b1) (= CP_U3_ROB_op Branch) (= CP_U3_ROB_exception #b1)) empty_ROB_int
					(ite (= CP_U3_ROB_done #b1) U3_ROB_destination_update
					U3_ROB_destination))
				)
				(U4_ROB_result 
					(ite (and (= CP_U3_ROB_done #b1) (= CP_U3_ROB_op Branch) (= CP_U3_ROB_exception #b1)) empty_ROB_int
					(ite (= CP_U3_ROB_done #b1) U3_ROB_result_update
					U3_ROB_result))
				)
				(U4_ROB_exception 
					(ite (and (= CP_U3_ROB_done #b1) (= CP_U3_ROB_op Branch) (= CP_U3_ROB_exception #b1)) empty_ROB_1bit
					(ite (= CP_U3_ROB_done #b1) U3_ROB_exception_update
					U3_ROB_exception))
				)
				(U4_ROB_done 
					(ite (and (= CP_U3_ROB_done #b1) (= CP_U3_ROB_op Branch) (= CP_U3_ROB_exception #b1)) empty_ROB_1bit
					(ite (= CP_U3_ROB_done #b1) U3_ROB_done_update
					U3_ROB_done))
				)
				
				(U4_ROB_Maddress 
					(ite (and (= CP_U3_ROB_done #b1) (= CP_U3_ROB_op Branch) (= CP_U3_ROB_exception #b1)) empty_ROB_int
					(ite (= CP_U3_ROB_done #b1) U3_ROB_Maddress_update
					U3_ROB_Maddress))
				)
				
				(U4_RS_op (ite (and (= CP_U3_ROB_done #b1) (= CP_U3_ROB_op Branch) (= CP_U3_ROB_exception #b1)) empty_RS_int U3_RS_op))
				(U4_RS_ROB_dst (ite (and (= CP_U3_ROB_done #b1) (= CP_U3_ROB_op Branch) (= CP_U3_ROB_exception #b1)) empty_RS_3bit U3_RS_ROB_dst))
				(U4_RS_vj (ite (and (= CP_U3_ROB_done #b1) (= CP_U3_ROB_op Branch) (= CP_U3_ROB_exception #b1)) empty_RS_int U3_RS_vj))
				(U4_RS_vk (ite (and (= CP_U3_ROB_done #b1) (= CP_U3_ROB_op Branch) (= CP_U3_ROB_exception #b1)) empty_RS_int U3_RS_vk))
				(U4_RS_qj (ite (and (= CP_U3_ROB_done #b1) (= CP_U3_ROB_op Branch) (= CP_U3_ROB_exception #b1)) empty_RS_3bit U3_RS_qj))
				(U4_RS_qk (ite (and (= CP_U3_ROB_done #b1) (= CP_U3_ROB_op Branch) (= CP_U3_ROB_exception #b1)) empty_RS_3bit U3_RS_qk))
				(U4_RS_imm (ite (and (= CP_U3_ROB_done #b1) (= CP_U3_ROB_op Branch) (= CP_U3_ROB_exception #b1)) empty_RS_int U3_RS_imm))
				(U4_RS_dis (ite (and (= CP_U3_ROB_done #b1) (= CP_U3_ROB_op Branch) (= CP_U3_ROB_exception #b1)) empty_RS_1bit U3_RS_dis))
				(U4_RS_busy (ite (and (= CP_U3_ROB_done #b1) (= CP_U3_ROB_op Branch) (= CP_U3_ROB_exception #b1)) empty_RS_1bit U3_RS_busy))
				
				(U4_LSQ_op (ite (and (= CP_U3_ROB_done #b1) (= CP_U3_ROB_op Branch) (= CP_U3_ROB_exception #b1)) empty_LSQ_int U3_LSQ_op))
				(U4_LSQ_ROB_dst (ite (and (= CP_U3_ROB_done #b1) (= CP_U3_ROB_op Branch) (= CP_U3_ROB_exception #b1)) empty_LSQ_3bit U3_LSQ_ROB_dst))
				(U4_LSQ_vj (ite (and (= CP_U3_ROB_done #b1) (= CP_U3_ROB_op Branch) (= CP_U3_ROB_exception #b1)) empty_LSQ_int U3_LSQ_vj))
				(U4_LSQ_vk (ite (and (= CP_U3_ROB_done #b1) (= CP_U3_ROB_op Branch) (= CP_U3_ROB_exception #b1)) empty_LSQ_int U3_LSQ_vk))
				(U4_LSQ_qj (ite (and (= CP_U3_ROB_done #b1) (= CP_U3_ROB_op Branch) (= CP_U3_ROB_exception #b1)) empty_LSQ_3bit U3_LSQ_qj))
				(U4_LSQ_qk (ite (and (= CP_U3_ROB_done #b1) (= CP_U3_ROB_op Branch) (= CP_U3_ROB_exception #b1)) empty_LSQ_3bit U3_LSQ_qk))
				(U4_LSQ_imm (ite (and (= CP_U3_ROB_done #b1) (= CP_U3_ROB_op Branch) (= CP_U3_ROB_exception #b1)) empty_LSQ_int U3_LSQ_imm))
				(U4_LSQ_dis (ite (and (= CP_U3_ROB_done #b1) (= CP_U3_ROB_op Branch) (= CP_U3_ROB_exception #b1)) empty_LSQ_1bit U3_LSQ_dis))
				(U4_LSQ_busy (ite (and (= CP_U3_ROB_done #b1) (= CP_U3_ROB_op Branch) (= CP_U3_ROB_exception #b1)) empty_LSQ_1bit U3_LSQ_busy))
				
				(U4_CacheL1_Tag (ite (= 0 0) U3_CacheL1_Tag U3_CacheL1_Tag))
				(U4_CacheL1_Data (ite (= 0 0) U3_CacheL1_Data U3_CacheL1_Data))
				(U4_CacheL1_Valid (ite (= 0 0) U3_CacheL1_Valid U3_CacheL1_Valid))
			)
;--======================================= Processor End ==================================================

;-----------------------------Calculations--------------------------------------------------------------		
		(let ((T_IP_m1 (subtract T_IP)))
		(let ((T_IP_m2 (subtract T_IP_m1)))
		(let ((T_IP_m3 (subtract T_IP_m2)))
		(let ((T_IP_m4 (subtract T_IP_m3)))
		(let ((T_IP_m5 (subtract T_IP_m4)))
		(let ((T_IP_m6 (subtract T_IP_m5)))
		(let ((T_IP_m7 (subtract T_IP_m6)))
		(let ((T_IP_m8 (subtract T_IP_m7)))		
        (let ((T_IP_m9 (subtract T_IP_m8)))
		(let ((T_IP_m10 (subtract T_IP_m9)))
		(let ((T_IP_m11 (subtract T_IP_m10)))
		(let ((T_IP_m12 (subtract T_IP_m11)))
		(let ((T_IP_m13 (subtract T_IP_m12)))
		(let ((T_IP_m14 (subtract T_IP_m13)))
		(let ((T_IP_m15 (subtract T_IP_m14)))
		(let ((T_IP_m16 (subtract T_IP_m15)))
		(let ((T_IP_m17 (subtract T_IP_m16)))
		(let ((T_IP_m18 (subtract T_IP_m17)))
		(let ((T_IP_m19 (subtract T_IP_m18)))
		(let ((T_IP_m20 (subtract T_IP_m19)))
		(let ((T_IP_m21 (subtract T_IP_m20)))
		(let ((T_IP_m22 (subtract T_IP_m21)))
		(let ((T_IP_m23 (subtract T_IP_m22)))
		(let ((T_IP_m24 (subtract T_IP_m23)))
		(let ((T_IP_m25 (subtract T_IP_m24)))
		(let ((T_IP_m26 (subtract T_IP_m25)))
		(let ((T_IP_m27 (subtract T_IP_m26)))
		(let ((T_IP_m28 (subtract T_IP_m27)))
		(let ((T_IP_m29 (subtract T_IP_m28)))
		(let ((T_IP_m30 (subtract T_IP_m29)))
		(let ((T_IP_m31 (subtract T_IP_m30)))
		(let ((T_IP_m32 (subtract T_IP_m31)))
		(let ((T_IP_m33 (subtract T_IP_m32)))
		(let ((T_IP_m34 (subtract T_IP_m33)))
		(let ((T_IP_m35 (subtract T_IP_m34)))
		(let ((T_IP_m36 (subtract T_IP_m35)))
		(let ((T_IP_m37 (subtract T_IP_m36)))
		(let ((T_IP_m38 (subtract T_IP_m37)))
		(let ((T_IP_m39 (subtract T_IP_m38)))
		(let ((T_IP_m40 (subtract T_IP_m39)))
		(let ((T_IP_m41 (subtract T_IP_m40)))
		(let ((T_IP_m42 (subtract T_IP_m41)))
		(let ((T_IP_m43 (subtract T_IP_m42)))
		(let ((T_IP_m44 (subtract T_IP_m43)))
		(let ((T_IP_m45 (subtract T_IP_m44)))
		(let ((T_IP_m46 (subtract T_IP_m45)))
		(let ((T_IP_m47 (subtract T_IP_m46)))
		(let ((T_IP_m48 (subtract T_IP_m47)))
		(let ((T_IP_m49 (subtract T_IP_m48)))
		(let ((T_IP_m50 (subtract T_IP_m49)))
		(let ((T_IP_m51 (subtract T_IP_m50)))
		(let ((T_IP_m52 (subtract T_IP_m51)))
		(let ((T_IP_m53 (subtract T_IP_m52)))
		(let ((T_IP_m54 (subtract T_IP_m53)))
		(let ((T_IP_m55 (subtract T_IP_m54)))
		(let ((T_IP_m56 (subtract T_IP_m55)))
		(let ((T_IP_m57 (subtract T_IP_m56)))
		(let ((T_IP_m58 (subtract T_IP_m57)))
		(let ((T_IP_m59 (subtract T_IP_m58)))
		(let ((T_IP_m60 (subtract T_IP_m59)))
		(let ((T_IP_m61 (subtract T_IP_m60)))
		(let ((T_IP_m62 (subtract T_IP_m61)))
		(let ((T_IP_m63 (subtract T_IP_m62)))

	
		(let ((U4_IP_m1 (subtract U4_IP)))
		(let ((U4_IP_m2 (subtract U4_IP_m1)))
		(let ((U4_IP_m3 (subtract U4_IP_m2)))
		(let ((U4_IP_m4 (subtract U4_IP_m3)))
		(let ((U4_IP_m5 (subtract U4_IP_m4)))
		(let ((U4_IP_m6 (subtract U4_IP_m5)))
		(let ((U4_IP_m7 (subtract U4_IP_m6)))
		(let ((U4_IP_m8 (subtract U4_IP_m7)))
		(let ((U4_IP_m9 (subtract U4_IP_m8)))
		(let ((U4_IP_m10 (subtract U4_IP_m9)))
		(let ((U4_IP_m11 (subtract U4_IP_m10)))
		(let ((U4_IP_m12 (subtract U4_IP_m11)))
		(let ((U4_IP_m13 (subtract U4_IP_m12)))
		(let ((U4_IP_m14 (subtract U4_IP_m13)))
		(let ((U4_IP_m15 (subtract U4_IP_m14)))
		(let ((U4_IP_m16 (subtract U4_IP_m15)))
		(let ((U4_IP_m17 (subtract U4_IP_m16)))
		(let ((U4_IP_m18 (subtract U4_IP_m17)))
		(let ((U4_IP_m19 (subtract U4_IP_m18)))
		(let ((U4_IP_m20 (subtract U4_IP_m19)))
		(let ((U4_IP_m21 (subtract U4_IP_m20)))
		(let ((U4_IP_m22 (subtract U4_IP_m21)))
		(let ((U4_IP_m23 (subtract U4_IP_m22)))
		(let ((U4_IP_m24 (subtract U4_IP_m23)))
		(let ((U4_IP_m25 (subtract U4_IP_m24)))
		(let ((U4_IP_m26 (subtract U4_IP_m25)))
		(let ((U4_IP_m27 (subtract U4_IP_m26)))
		(let ((U4_IP_m28 (subtract U4_IP_m27)))
		(let ((U4_IP_m29 (subtract U4_IP_m28)))
		(let ((U4_IP_m30 (subtract U4_IP_m29)))
		(let ((U4_IP_m31 (subtract U4_IP_m30)))
		(let ((U4_IP_m32 (subtract U4_IP_m31)))
		(let ((U4_IP_m33 (subtract U4_IP_m32)))
		(let ((U4_IP_m34 (subtract U4_IP_m33)))
		(let ((U4_IP_m35 (subtract U4_IP_m34)))
		(let ((U4_IP_m36 (subtract U4_IP_m35)))
		(let ((U4_IP_m37 (subtract U4_IP_m36)))
		(let ((U4_IP_m38 (subtract U4_IP_m37)))
		(let ((U4_IP_m39 (subtract U4_IP_m38)))
		(let ((U4_IP_m40 (subtract U4_IP_m39)))
		(let ((U4_IP_m41 (subtract U4_IP_m40)))
		(let ((U4_IP_m42 (subtract U4_IP_m41)))
		(let ((U4_IP_m43 (subtract U4_IP_m42)))
		(let ((U4_IP_m44 (subtract U4_IP_m43)))
		(let ((U4_IP_m45 (subtract U4_IP_m44)))
		(let ((U4_IP_m46 (subtract U4_IP_m45)))
		(let ((U4_IP_m47 (subtract U4_IP_m46)))
		(let ((U4_IP_m48 (subtract U4_IP_m47)))
		(let ((U4_IP_m49 (subtract U4_IP_m48)))
		(let ((U4_IP_m50 (subtract U4_IP_m49)))
		(let ((U4_IP_m51 (subtract U4_IP_m50)))
		(let ((U4_IP_m52 (subtract U4_IP_m51)))
		(let ((U4_IP_m53 (subtract U4_IP_m52)))
		(let ((U4_IP_m54 (subtract U4_IP_m53)))
		(let ((U4_IP_m55 (subtract U4_IP_m54)))
		(let ((U4_IP_m56 (subtract U4_IP_m55)))
		(let ((U4_IP_m57 (subtract U4_IP_m56)))
		(let ((U4_IP_m58 (subtract U4_IP_m57)))
		(let ((U4_IP_m59 (subtract U4_IP_m58)))
		(let ((U4_IP_m60 (subtract U4_IP_m59)))
		(let ((U4_IP_m61 (subtract U4_IP_m60)))
		(let ((U4_IP_m62 (subtract U4_IP_m61)))
		(let ((U4_IP_m63 (subtract U4_IP_m62)))
		
		(let
			(
				(T_cache_valid0 (select T_Cache_Valid (_ bv0 2)))
				(T_cache_valid1 (select T_Cache_Valid (_ bv1 2)))
				(T_cache_valid2 (select T_Cache_Valid (_ bv2 2)))
				(T_cache_valid3 (select T_Cache_Valid (_ bv3 2)))
				
				(T_cache_address0 (select T_Cache_Tag (_ bv0 2)))
				(T_cache_address1 (select T_Cache_Tag (_ bv1 2)))
				(T_cache_address2 (select T_Cache_Tag (_ bv2 2)))
				(T_cache_address3 (select T_Cache_Tag (_ bv3 2)))
			)
		(let
			(
				(T_cache_TC0 (pointer_TC T_cache_address0))
				(T_cache_TC1 (pointer_TC T_cache_address1))
				(T_cache_TC2 (pointer_TC T_cache_address2))
				(T_cache_TC3 (pointer_TC T_cache_address3))
				
				(T_cache_SC0 (pointer_SC T_cache_address0))
				(T_cache_SC1 (pointer_SC T_cache_address1))
				(T_cache_SC2 (pointer_SC T_cache_address2))
				(T_cache_SC3 (pointer_SC T_cache_address3))
				
				(T_cache_PID0 (pointer_ID T_cache_address0))
				(T_cache_PID1 (pointer_ID T_cache_address1))
				(T_cache_PID2 (pointer_ID T_cache_address2))
				(T_cache_PID3 (pointer_ID T_cache_address3))
				
				(T_cache_OID0 (Object_ID T_cache_address0))
				(T_cache_OID1 (Object_ID T_cache_address1))
				(T_cache_OID2 (Object_ID T_cache_address2))
				(T_cache_OID3 (Object_ID T_cache_address3))
				
				(T_cache_Base0 (Base T_cache_address0))
				(T_cache_Base1 (Base T_cache_address1))
				(T_cache_Base2 (Base T_cache_address2))
				(T_cache_Base3 (Base T_cache_address3))
				
				(T_cache_Bound0 (Bound T_cache_address0))
				(T_cache_Bound1 (Bound T_cache_address1))
				(T_cache_Bound2 (Bound T_cache_address2))
				(T_cache_Bound3 (Bound T_cache_address3))
			)
		(let
			(
				(T_SC_Flag0 (ite (and (> T_cache_address0 T_cache_Base0) (< T_cache_address0 T_cache_Bound0)) (_ bv1 1) (_ bv0 1))) ;make it geq
				(T_SC_Flag1 (ite (and (> T_cache_address1 T_cache_Base1) (< T_cache_address1 T_cache_Bound1)) (_ bv1 1) (_ bv0 1))) ;make it geq
				(T_SC_Flag2 (ite (and (> T_cache_address2 T_cache_Base2) (< T_cache_address2 T_cache_Bound2)) (_ bv1 1) (_ bv0 1))) ;make it geq
				(T_SC_Flag3 (ite (and (> T_cache_address3 T_cache_Base3) (< T_cache_address3 T_cache_Bound3)) (_ bv1 1) (_ bv0 1))) ;make it geq
				
				(T_TC_Flag0 (ite (= T_cache_OID0 T_cache_PID0) (_ bv1 1) (_ bv0 1)))
				(T_TC_Flag1 (ite (= T_cache_OID1 T_cache_PID1) (_ bv1 1) (_ bv0 1)))
				(T_TC_Flag2 (ite (= T_cache_OID2 T_cache_PID2) (_ bv1 1) (_ bv0 1)))
				(T_TC_Flag3 (ite (= T_cache_OID3 T_cache_PID3) (_ bv1 1) (_ bv0 1)))
			)
		(let
			(
				(T_SC_pass0
					(ite (and (= T_cache_SC0 #b1) (= T_SC_Flag0 #b1)) (_ bv1 1)	;--Needs check and passed
					(ite (= T_cache_SC0 #b0) (_ bv1 1)	;--no checking required
					(_ bv0 1)))	;--check failed
				)
				(T_SC_pass1
					(ite (and (= T_cache_SC1 #b1) (= T_SC_Flag1 #b1)) (_ bv1 1)	;--Needs check and passed
					(ite (= T_cache_SC1 #b0) (_ bv1 1)	;--no checking required
					(_ bv0 1)))	;--check failed
				)
				(T_SC_pass2
					(ite (and (= T_cache_SC2 #b1) (= T_SC_Flag2 #b1)) (_ bv1 1)	;--Needs check and passed
					(ite (= T_cache_SC2 #b0) (_ bv1 1)	;--no checking required
					(_ bv0 1)))	;--check failed
				)
				(T_SC_pass3
					(ite (and (= T_cache_SC3 #b1) (= T_SC_Flag3 #b1)) (_ bv1 1)	;--Needs check and passed
					(ite (= T_cache_SC3 #b0) (_ bv1 1)	;--no checking required
					(_ bv0 1)))	;--check failed
				)
				
				(T_TC_pass0
					(ite (and (= T_cache_TC0 #b1) (= T_TC_Flag0 #b1)) (_ bv1 1)	;--Needs check and passed
					(ite (= T_cache_TC0 #b0) (_ bv1 1)	;--no checking required
					(_ bv0 1)))	;--check failed
				)
				(T_TC_pass1
					(ite (and (= T_cache_TC1 #b1) (= T_TC_Flag1 #b1)) (_ bv1 1)	;--Needs check and passed
					(ite (= T_cache_TC1 #b0) (_ bv1 1)	;--no checking required
					(_ bv0 1)))	;--check failed
				)
				(T_TC_pass2
					(ite (and (= T_cache_TC2 #b1) (= T_TC_Flag2 #b1)) (_ bv1 1)	;--Needs check and passed
					(ite (= T_cache_TC2 #b0) (_ bv1 1)	;--no checking required
					(_ bv0 1)))	;--check failed
				)
				(T_TC_pass3
					(ite (and (= T_cache_TC3 #b1) (= T_TC_Flag3 #b1)) (_ bv1 1)	;--Needs check and passed
					(ite (= T_cache_TC3 #b0) (_ bv1 1)	;--no checking required
					(_ bv0 1)))	;--check failed
				)
			)


		(let
			(
				(U4_cache_valid0 (select U4_CacheL1_Valid (_ bv0 2)))
				(U4_cache_valid1 (select U4_CacheL1_Valid (_ bv1 2)))
				(U4_cache_valid2 (select U4_CacheL1_Valid (_ bv2 2)))
				(U4_cache_valid3 (select U4_CacheL1_Valid (_ bv3 2)))
				
				(U4_cache_address0 (select U4_CacheL1_Tag (_ bv0 2)))
				(U4_cache_address1 (select U4_CacheL1_Tag (_ bv1 2)))
				(U4_cache_address2 (select U4_CacheL1_Tag (_ bv2 2)))
				(U4_cache_address3 (select U4_CacheL1_Tag (_ bv3 2)))
			)
		(let
			(
				(U4_cache_TC0 (pointer_TC U4_cache_address0))
				(U4_cache_TC1 (pointer_TC U4_cache_address1))
				(U4_cache_TC2 (pointer_TC U4_cache_address2))
				(U4_cache_TC3 (pointer_TC U4_cache_address3))
				
				(U4_cache_SC0 (pointer_SC U4_cache_address0))
				(U4_cache_SC1 (pointer_SC U4_cache_address1))
				(U4_cache_SC2 (pointer_SC U4_cache_address2))
				(U4_cache_SC3 (pointer_SC U4_cache_address3))
				
				(U4_cache_PID0 (pointer_ID U4_cache_address0))
				(U4_cache_PID1 (pointer_ID U4_cache_address1))
				(U4_cache_PID2 (pointer_ID U4_cache_address2))
				(U4_cache_PID3 (pointer_ID U4_cache_address3))
				
				(U4_cache_OID0 (Object_ID U4_cache_address0))
				(U4_cache_OID1 (Object_ID U4_cache_address1))
				(U4_cache_OID2 (Object_ID U4_cache_address2))
				(U4_cache_OID3 (Object_ID U4_cache_address3))
				
				(U4_cache_Base0 (Base U4_cache_address0))
				(U4_cache_Base1 (Base U4_cache_address1))
				(U4_cache_Base2 (Base U4_cache_address2))
				(U4_cache_Base3 (Base U4_cache_address3))
				
				(U4_cache_Bound0 (Bound U4_cache_address0))
				(U4_cache_Bound1 (Bound U4_cache_address1))
				(U4_cache_Bound2 (Bound U4_cache_address2))
				(U4_cache_Bound3 (Bound U4_cache_address3))
			)
		(let
			(
				(U4_SC_Flag0 (ite (and (> U4_cache_address0 U4_cache_Base0 ) (< U4_cache_address0 U4_cache_Bound0)) (_ bv1 1) (_ bv0 1))) ;make it geq
				(U4_SC_Flag1 (ite (and (> U4_cache_address1 U4_cache_Base1 ) (< U4_cache_address1 U4_cache_Bound1)) (_ bv1 1) (_ bv0 1))) ;make it geq
				(U4_SC_Flag2 (ite (and (> U4_cache_address2 U4_cache_Base2 ) (< U4_cache_address2 U4_cache_Bound2)) (_ bv1 1) (_ bv0 1))) ;make it geq
				(U4_SC_Flag3 (ite (and (> U4_cache_address3 U4_cache_Base3 ) (< U4_cache_address3 U4_cache_Bound3)) (_ bv1 1) (_ bv0 1))) ;make it geq
				
				(U4_TC_Flag0 (ite (= U4_cache_OID0 U4_cache_PID0) (_ bv1 1) (_ bv0 1)))
				(U4_TC_Flag1 (ite (= U4_cache_OID1 U4_cache_PID1) (_ bv1 1) (_ bv0 1)))
				(U4_TC_Flag2 (ite (= U4_cache_OID2 U4_cache_PID2) (_ bv1 1) (_ bv0 1)))
				(U4_TC_Flag3 (ite (= U4_cache_OID3 U4_cache_PID3) (_ bv1 1) (_ bv0 1)))
			)
		(let
			(
				(U4_SC_pass0
					(ite (and (= U4_cache_SC0 #b1) (= U4_SC_Flag0 #b1)) (_ bv1 1)	;--Needs check and passed
					(ite (= U4_cache_SC0 #b0) (_ bv1 1)	;--no checking required
					(_ bv0 1)))	;--check failed
				)
				(U4_SC_pass1
					(ite (and (= U4_cache_SC1 #b1) (= U4_SC_Flag1 #b1)) (_ bv1 1)	;--Needs check and passed
					(ite (= U4_cache_SC1 #b0) (_ bv1 1)	;--no checking required
					(_ bv0 1)))	;--check failed
				)
				(U4_SC_pass2
					(ite (and (= U4_cache_SC2 #b1) (= U4_SC_Flag2 #b1)) (_ bv1 1)	;--Needs check and passed
					(ite (= U4_cache_SC2 #b0) (_ bv1 1)	;--no checking required
					(_ bv0 1)))	;--check failed
				)
				(U4_SC_pass3
					(ite (and (= U4_cache_SC3 #b1) (= U4_SC_Flag3 #b1)) (_ bv1 1)	;--Needs check and passed
					(ite (= U4_cache_SC3 #b0) (_ bv1 1)	;--no checking required
					(_ bv0 1)))	;--check failed
				)
				
				(U4_TC_pass0
					(ite (and (= U4_cache_TC0 #b1) (= U4_TC_Flag0 #b1)) (_ bv1 1)	;--Needs check and passed
					(ite (= U4_cache_TC0 #b0) (_ bv1 1)	;--no checking required
					(_ bv0 1)))	;--check failed
				)
				(U4_TC_pass1
					(ite (and (= U4_cache_TC1 #b1) (= U4_TC_Flag1 #b1)) (_ bv1 1)	;--Needs check and passed
					(ite (= U4_cache_TC1 #b0) (_ bv1 1)	;--no checking required
					(_ bv0 1)))	;--check failed
				)
				(U4_TC_pass2
					(ite (and (= U4_cache_TC2 #b1) (= U4_TC_Flag2 #b1)) (_ bv1 1)	;--Needs check and passed
					(ite (= U4_cache_TC2 #b0) (_ bv1 1)	;--no checking required
					(_ bv0 1)))	;--check failed
				)
				(U4_TC_pass3
					(ite (and (= U4_cache_TC3 #b1) (= U4_TC_Flag3 #b1)) (_ bv1 1)	;--Needs check and passed
					(ite (= U4_cache_TC3 #b0) (_ bv1 1)	;--no checking required
					(_ bv0 1)))	;--check failed
				)
			)	
;-----------------------------Property--------------------------------------------------------------		
		(=>
			(and
;-----------------------------General Invarint 1 IP and CP are never 0 (ROB 0 is not used)-------------------------------------------------
				(not (= T_IP #b000000)) 	;done
				(not (= T_CP #b000000))	;done

;-----------------------------General Invarint 2 ROB0 is never busy (ROB 0 not used)-------------------------------------------------
				(= #b0 (select T_ROB_busy (_ bv0 6)))	;done

;(----------------------------General Invarint 3 If a ROB entry is not busy, then its empty ()-------------------------------------------------
				(=> (= #b0 (select T_ROB_busy (_ bv0 6))) (and (= (select T_ROB_op (_ bv0 6)) 0) (= (select T_ROB_destination (_ bv0 6)) 0) (= (select T_ROB_result (_ bv0 6)) 0) (= (select T_ROB_exception (_ bv0 6)) #b0) (= (select T_ROB_done (_ bv0 6)) #b0) ))
				(=> (= #b0 (select T_ROB_busy (_ bv1 6))) (and (= (select T_ROB_op (_ bv1 6)) 0) (= (select T_ROB_destination (_ bv1 6)) 0) (= (select T_ROB_result (_ bv1 6)) 0) (= (select T_ROB_exception (_ bv1 6)) #b0) (= (select T_ROB_done (_ bv1 6)) #b0) ))
				(=> (= #b0 (select T_ROB_busy (_ bv2 6))) (and (= (select T_ROB_op (_ bv2 6)) 0) (= (select T_ROB_destination (_ bv2 6)) 0) (= (select T_ROB_result (_ bv2 6)) 0) (= (select T_ROB_exception (_ bv2 6)) #b0) (= (select T_ROB_done (_ bv2 6)) #b0) ))
				(=> (= #b0 (select T_ROB_busy (_ bv3 6))) (and (= (select T_ROB_op (_ bv3 6)) 0) (= (select T_ROB_destination (_ bv3 6)) 0) (= (select T_ROB_result (_ bv3 6)) 0) (= (select T_ROB_exception (_ bv3 6)) #b0) (= (select T_ROB_done (_ bv3 6)) #b0) ))
				(=> (= #b0 (select T_ROB_busy (_ bv4 6))) (and (= (select T_ROB_op (_ bv4 6)) 0) (= (select T_ROB_destination (_ bv4 6)) 0) (= (select T_ROB_result (_ bv4 6)) 0) (= (select T_ROB_exception (_ bv4 6)) #b0) (= (select T_ROB_done (_ bv4 6)) #b0) ))
				(=> (= #b0 (select T_ROB_busy (_ bv5 6))) (and (= (select T_ROB_op (_ bv5 6)) 0) (= (select T_ROB_destination (_ bv5 6)) 0) (= (select T_ROB_result (_ bv5 6)) 0) (= (select T_ROB_exception (_ bv5 6)) #b0) (= (select T_ROB_done (_ bv5 6)) #b0) ))
				(=> (= #b0 (select T_ROB_busy (_ bv6 6))) (and (= (select T_ROB_op (_ bv6 6)) 0) (= (select T_ROB_destination (_ bv6 6)) 0) (= (select T_ROB_result (_ bv6 6)) 0) (= (select T_ROB_exception (_ bv6 6)) #b0) (= (select T_ROB_done (_ bv6 6)) #b0) ))
				(=> (= #b0 (select T_ROB_busy (_ bv7 6))) (and (= (select T_ROB_op (_ bv7 6)) 0) (= (select T_ROB_destination (_ bv7 6)) 0) (= (select T_ROB_result (_ bv7 6)) 0) (= (select T_ROB_exception (_ bv7 6)) #b0) (= (select T_ROB_done (_ bv7 6)) #b0) ))
                (=> (= #b0 (select T_ROB_busy (_ bv8 6))) (and (= (select T_ROB_op (_ bv8 6)) 0) (= (select T_ROB_destination (_ bv8 6)) 0) (= (select T_ROB_result (_ bv8 6)) 0) (= (select T_ROB_exception (_ bv8 6)) #b0) (= (select T_ROB_done (_ bv8 6)) #b0) ))
				(=> (= #b0 (select T_ROB_busy (_ bv9 6))) (and (= (select T_ROB_op (_ bv9 6)) 0) (= (select T_ROB_destination (_ bv9 6)) 0) (= (select T_ROB_result (_ bv9 6)) 0) (= (select T_ROB_exception (_ bv9 6)) #b0) (= (select T_ROB_done (_ bv9 6)) #b0) ))
				(=> (= #b0 (select T_ROB_busy (_ bv10 6))) (and (= (select T_ROB_op (_ bv10 6)) 0) (= (select T_ROB_destination (_ bv10 6)) 0) (= (select T_ROB_result (_ bv10 6)) 0) (= (select T_ROB_exception (_ bv10 6)) #b0) (= (select T_ROB_done (_ bv10 6)) #b0) ))
				(=> (= #b0 (select T_ROB_busy (_ bv11 6))) (and (= (select T_ROB_op (_ bv11 6)) 0) (= (select T_ROB_destination (_ bv11 6)) 0) (= (select T_ROB_result (_ bv11 6)) 0) (= (select T_ROB_exception (_ bv11 6)) #b0) (= (select T_ROB_done (_ bv11 6)) #b0) ))
				(=> (= #b0 (select T_ROB_busy (_ bv12 6))) (and (= (select T_ROB_op (_ bv12 6)) 0) (= (select T_ROB_destination (_ bv12 6)) 0) (= (select T_ROB_result (_ bv12 6)) 0) (= (select T_ROB_exception (_ bv12 6)) #b0) (= (select T_ROB_done (_ bv12 6)) #b0) ))
				(=> (= #b0 (select T_ROB_busy (_ bv13 6))) (and (= (select T_ROB_op (_ bv13 6)) 0) (= (select T_ROB_destination (_ bv13 6)) 0) (= (select T_ROB_result (_ bv13 6)) 0) (= (select T_ROB_exception (_ bv13 6)) #b0) (= (select T_ROB_done (_ bv13 6)) #b0) ))
				(=> (= #b0 (select T_ROB_busy (_ bv14 6))) (and (= (select T_ROB_op (_ bv14 6)) 0) (= (select T_ROB_destination (_ bv14 6)) 0) (= (select T_ROB_result (_ bv14 6)) 0) (= (select T_ROB_exception (_ bv14 6)) #b0) (= (select T_ROB_done (_ bv14 6)) #b0) ))
				(=> (= #b0 (select T_ROB_busy (_ bv15 6))) (and (= (select T_ROB_op (_ bv15 6)) 0) (= (select T_ROB_destination (_ bv15 6)) 0) (= (select T_ROB_result (_ bv15 6)) 0) (= (select T_ROB_exception (_ bv15 6)) #b0) (= (select T_ROB_done (_ bv15 6)) #b0) ))
				(=> (= #b0 (select T_ROB_busy (_ bv16 6))) (and (= (select T_ROB_op (_ bv16 6)) 0) (= (select T_ROB_destination (_ bv16 6)) 0) (= (select T_ROB_result (_ bv16 6)) 0) (= (select T_ROB_exception (_ bv16 6)) #b0) (= (select T_ROB_done (_ bv16 6)) #b0) ))
				(=> (= #b0 (select T_ROB_busy (_ bv17 6))) (and (= (select T_ROB_op (_ bv17 6)) 0) (= (select T_ROB_destination (_ bv17 6)) 0) (= (select T_ROB_result (_ bv17 6)) 0) (= (select T_ROB_exception (_ bv17 6)) #b0) (= (select T_ROB_done (_ bv17 6)) #b0) ))
				(=> (= #b0 (select T_ROB_busy (_ bv18 6))) (and (= (select T_ROB_op (_ bv18 6)) 0) (= (select T_ROB_destination (_ bv18 6)) 0) (= (select T_ROB_result (_ bv18 6)) 0) (= (select T_ROB_exception (_ bv18 6)) #b0) (= (select T_ROB_done (_ bv18 6)) #b0) ))
				(=> (= #b0 (select T_ROB_busy (_ bv19 6))) (and (= (select T_ROB_op (_ bv19 6)) 0) (= (select T_ROB_destination (_ bv19 6)) 0) (= (select T_ROB_result (_ bv19 6)) 0) (= (select T_ROB_exception (_ bv19 6)) #b0) (= (select T_ROB_done (_ bv19 6)) #b0) ))
				(=> (= #b0 (select T_ROB_busy (_ bv20 6))) (and (= (select T_ROB_op (_ bv20 6)) 0) (= (select T_ROB_destination (_ bv20 6)) 0) (= (select T_ROB_result (_ bv20 6)) 0) (= (select T_ROB_exception (_ bv20 6)) #b0) (= (select T_ROB_done (_ bv20 6)) #b0) ))
				(=> (= #b0 (select T_ROB_busy (_ bv21 6))) (and (= (select T_ROB_op (_ bv21 6)) 0) (= (select T_ROB_destination (_ bv21 6)) 0) (= (select T_ROB_result (_ bv21 6)) 0) (= (select T_ROB_exception (_ bv21 6)) #b0) (= (select T_ROB_done (_ bv21 6)) #b0) ))
				(=> (= #b0 (select T_ROB_busy (_ bv22 6))) (and (= (select T_ROB_op (_ bv22 6)) 0) (= (select T_ROB_destination (_ bv22 6)) 0) (= (select T_ROB_result (_ bv22 6)) 0) (= (select T_ROB_exception (_ bv22 6)) #b0) (= (select T_ROB_done (_ bv22 6)) #b0) ))
				(=> (= #b0 (select T_ROB_busy (_ bv23 6))) (and (= (select T_ROB_op (_ bv23 6)) 0) (= (select T_ROB_destination (_ bv23 6)) 0) (= (select T_ROB_result (_ bv23 6)) 0) (= (select T_ROB_exception (_ bv23 6)) #b0) (= (select T_ROB_done (_ bv23 6)) #b0) ))
				(=> (= #b0 (select T_ROB_busy (_ bv24 6))) (and (= (select T_ROB_op (_ bv24 6)) 0) (= (select T_ROB_destination (_ bv24 6)) 0) (= (select T_ROB_result (_ bv24 6)) 0) (= (select T_ROB_exception (_ bv24 6)) #b0) (= (select T_ROB_done (_ bv24 6)) #b0) ))
				(=> (= #b0 (select T_ROB_busy (_ bv25 6))) (and (= (select T_ROB_op (_ bv25 6)) 0) (= (select T_ROB_destination (_ bv25 6)) 0) (= (select T_ROB_result (_ bv25 6)) 0) (= (select T_ROB_exception (_ bv25 6)) #b0) (= (select T_ROB_done (_ bv25 6)) #b0) ))
				(=> (= #b0 (select T_ROB_busy (_ bv26 6))) (and (= (select T_ROB_op (_ bv26 6)) 0) (= (select T_ROB_destination (_ bv26 6)) 0) (= (select T_ROB_result (_ bv26 6)) 0) (= (select T_ROB_exception (_ bv26 6)) #b0) (= (select T_ROB_done (_ bv26 6)) #b0) ))
				(=> (= #b0 (select T_ROB_busy (_ bv27 6))) (and (= (select T_ROB_op (_ bv27 6)) 0) (= (select T_ROB_destination (_ bv27 6)) 0) (= (select T_ROB_result (_ bv27 6)) 0) (= (select T_ROB_exception (_ bv27 6)) #b0) (= (select T_ROB_done (_ bv27 6)) #b0) ))
				(=> (= #b0 (select T_ROB_busy (_ bv28 6))) (and (= (select T_ROB_op (_ bv28 6)) 0) (= (select T_ROB_destination (_ bv28 6)) 0) (= (select T_ROB_result (_ bv28 6)) 0) (= (select T_ROB_exception (_ bv28 6)) #b0) (= (select T_ROB_done (_ bv28 6)) #b0) ))
				(=> (= #b0 (select T_ROB_busy (_ bv29 6))) (and (= (select T_ROB_op (_ bv29 6)) 0) (= (select T_ROB_destination (_ bv29 6)) 0) (= (select T_ROB_result (_ bv29 6)) 0) (= (select T_ROB_exception (_ bv29 6)) #b0) (= (select T_ROB_done (_ bv29 6)) #b0) ))
				(=> (= #b0 (select T_ROB_busy (_ bv30 6))) (and (= (select T_ROB_op (_ bv30 6)) 0) (= (select T_ROB_destination (_ bv30 6)) 0) (= (select T_ROB_result (_ bv30 6)) 0) (= (select T_ROB_exception (_ bv30 6)) #b0) (= (select T_ROB_done (_ bv30 6)) #b0) ))
				(=> (= #b0 (select T_ROB_busy (_ bv31 6))) (and (= (select T_ROB_op (_ bv31 6)) 0) (= (select T_ROB_destination (_ bv31 6)) 0) (= (select T_ROB_result (_ bv31 6)) 0) (= (select T_ROB_exception (_ bv31 6)) #b0) (= (select T_ROB_done (_ bv31 6)) #b0) ))
				(=> (= #b0 (select T_ROB_busy (_ bv32 6))) (and (= (select T_ROB_op (_ bv32 6)) 0) (= (select T_ROB_destination (_ bv32 6)) 0) (= (select T_ROB_result (_ bv32 6)) 0) (= (select T_ROB_exception (_ bv32 6)) #b0) (= (select T_ROB_done (_ bv32 6)) #b0) ))
				(=> (= #b0 (select T_ROB_busy (_ bv33 6))) (and (= (select T_ROB_op (_ bv33 6)) 0) (= (select T_ROB_destination (_ bv33 6)) 0) (= (select T_ROB_result (_ bv33 6)) 0) (= (select T_ROB_exception (_ bv33 6)) #b0) (= (select T_ROB_done (_ bv33 6)) #b0) ))
				(=> (= #b0 (select T_ROB_busy (_ bv34 6))) (and (= (select T_ROB_op (_ bv34 6)) 0) (= (select T_ROB_destination (_ bv34 6)) 0) (= (select T_ROB_result (_ bv34 6)) 0) (= (select T_ROB_exception (_ bv34 6)) #b0) (= (select T_ROB_done (_ bv34 6)) #b0) ))
				(=> (= #b0 (select T_ROB_busy (_ bv35 6))) (and (= (select T_ROB_op (_ bv35 6)) 0) (= (select T_ROB_destination (_ bv35 6)) 0) (= (select T_ROB_result (_ bv35 6)) 0) (= (select T_ROB_exception (_ bv35 6)) #b0) (= (select T_ROB_done (_ bv35 6)) #b0) ))
				(=> (= #b0 (select T_ROB_busy (_ bv36 6))) (and (= (select T_ROB_op (_ bv36 6)) 0) (= (select T_ROB_destination (_ bv36 6)) 0) (= (select T_ROB_result (_ bv36 6)) 0) (= (select T_ROB_exception (_ bv36 6)) #b0) (= (select T_ROB_done (_ bv36 6)) #b0) ))
				(=> (= #b0 (select T_ROB_busy (_ bv37 6))) (and (= (select T_ROB_op (_ bv37 6)) 0) (= (select T_ROB_destination (_ bv37 6)) 0) (= (select T_ROB_result (_ bv37 6)) 0) (= (select T_ROB_exception (_ bv37 6)) #b0) (= (select T_ROB_done (_ bv37 6)) #b0) ))
				(=> (= #b0 (select T_ROB_busy (_ bv38 6))) (and (= (select T_ROB_op (_ bv38 6)) 0) (= (select T_ROB_destination (_ bv38 6)) 0) (= (select T_ROB_result (_ bv38 6)) 0) (= (select T_ROB_exception (_ bv38 6)) #b0) (= (select T_ROB_done (_ bv38 6)) #b0) ))
				(=> (= #b0 (select T_ROB_busy (_ bv39 6))) (and (= (select T_ROB_op (_ bv39 6)) 0) (= (select T_ROB_destination (_ bv39 6)) 0) (= (select T_ROB_result (_ bv39 6)) 0) (= (select T_ROB_exception (_ bv39 6)) #b0) (= (select T_ROB_done (_ bv39 6)) #b0) ))
				(=> (= #b0 (select T_ROB_busy (_ bv40 6))) (and (= (select T_ROB_op (_ bv40 6)) 0) (= (select T_ROB_destination (_ bv40 6)) 0) (= (select T_ROB_result (_ bv40 6)) 0) (= (select T_ROB_exception (_ bv40 6)) #b0) (= (select T_ROB_done (_ bv40 6)) #b0) ))
				(=> (= #b0 (select T_ROB_busy (_ bv41 6))) (and (= (select T_ROB_op (_ bv41 6)) 0) (= (select T_ROB_destination (_ bv41 6)) 0) (= (select T_ROB_result (_ bv41 6)) 0) (= (select T_ROB_exception (_ bv41 6)) #b0) (= (select T_ROB_done (_ bv41 6)) #b0) ))
				(=> (= #b0 (select T_ROB_busy (_ bv42 6))) (and (= (select T_ROB_op (_ bv42 6)) 0) (= (select T_ROB_destination (_ bv42 6)) 0) (= (select T_ROB_result (_ bv42 6)) 0) (= (select T_ROB_exception (_ bv42 6)) #b0) (= (select T_ROB_done (_ bv42 6)) #b0) ))
				(=> (= #b0 (select T_ROB_busy (_ bv43 6))) (and (= (select T_ROB_op (_ bv43 6)) 0) (= (select T_ROB_destination (_ bv43 6)) 0) (= (select T_ROB_result (_ bv43 6)) 0) (= (select T_ROB_exception (_ bv43 6)) #b0) (= (select T_ROB_done (_ bv43 6)) #b0) ))
				(=> (= #b0 (select T_ROB_busy (_ bv44 6))) (and (= (select T_ROB_op (_ bv44 6)) 0) (= (select T_ROB_destination (_ bv44 6)) 0) (= (select T_ROB_result (_ bv44 6)) 0) (= (select T_ROB_exception (_ bv44 6)) #b0) (= (select T_ROB_done (_ bv44 6)) #b0) ))
				(=> (= #b0 (select T_ROB_busy (_ bv45 6))) (and (= (select T_ROB_op (_ bv45 6)) 0) (= (select T_ROB_destination (_ bv45 6)) 0) (= (select T_ROB_result (_ bv45 6)) 0) (= (select T_ROB_exception (_ bv45 6)) #b0) (= (select T_ROB_done (_ bv45 6)) #b0) ))
				(=> (= #b0 (select T_ROB_busy (_ bv46 6))) (and (= (select T_ROB_op (_ bv46 6)) 0) (= (select T_ROB_destination (_ bv46 6)) 0) (= (select T_ROB_result (_ bv46 6)) 0) (= (select T_ROB_exception (_ bv46 6)) #b0) (= (select T_ROB_done (_ bv46 6)) #b0) ))
				(=> (= #b0 (select T_ROB_busy (_ bv47 6))) (and (= (select T_ROB_op (_ bv47 6)) 0) (= (select T_ROB_destination (_ bv47 6)) 0) (= (select T_ROB_result (_ bv47 6)) 0) (= (select T_ROB_exception (_ bv47 6)) #b0) (= (select T_ROB_done (_ bv47 6)) #b0) ))
				(=> (= #b0 (select T_ROB_busy (_ bv48 6))) (and (= (select T_ROB_op (_ bv48 6)) 0) (= (select T_ROB_destination (_ bv48 6)) 0) (= (select T_ROB_result (_ bv48 6)) 0) (= (select T_ROB_exception (_ bv48 6)) #b0) (= (select T_ROB_done (_ bv48 6)) #b0) ))
				(=> (= #b0 (select T_ROB_busy (_ bv49 6))) (and (= (select T_ROB_op (_ bv49 6)) 0) (= (select T_ROB_destination (_ bv49 6)) 0) (= (select T_ROB_result (_ bv49 6)) 0) (= (select T_ROB_exception (_ bv49 6)) #b0) (= (select T_ROB_done (_ bv49 6)) #b0) ))
				(=> (= #b0 (select T_ROB_busy (_ bv50 6))) (and (= (select T_ROB_op (_ bv50 6)) 0) (= (select T_ROB_destination (_ bv50 6)) 0) (= (select T_ROB_result (_ bv50 6)) 0) (= (select T_ROB_exception (_ bv50 6)) #b0) (= (select T_ROB_done (_ bv50 6)) #b0) ))
				(=> (= #b0 (select T_ROB_busy (_ bv51 6))) (and (= (select T_ROB_op (_ bv51 6)) 0) (= (select T_ROB_destination (_ bv51 6)) 0) (= (select T_ROB_result (_ bv51 6)) 0) (= (select T_ROB_exception (_ bv51 6)) #b0) (= (select T_ROB_done (_ bv51 6)) #b0) ))
				(=> (= #b0 (select T_ROB_busy (_ bv52 6))) (and (= (select T_ROB_op (_ bv52 6)) 0) (= (select T_ROB_destination (_ bv52 6)) 0) (= (select T_ROB_result (_ bv52 6)) 0) (= (select T_ROB_exception (_ bv52 6)) #b0) (= (select T_ROB_done (_ bv52 6)) #b0) ))
				(=> (= #b0 (select T_ROB_busy (_ bv53 6))) (and (= (select T_ROB_op (_ bv53 6)) 0) (= (select T_ROB_destination (_ bv53 6)) 0) (= (select T_ROB_result (_ bv53 6)) 0) (= (select T_ROB_exception (_ bv53 6)) #b0) (= (select T_ROB_done (_ bv53 6)) #b0) ))
				(=> (= #b0 (select T_ROB_busy (_ bv54 6))) (and (= (select T_ROB_op (_ bv54 6)) 0) (= (select T_ROB_destination (_ bv54 6)) 0) (= (select T_ROB_result (_ bv54 6)) 0) (= (select T_ROB_exception (_ bv54 6)) #b0) (= (select T_ROB_done (_ bv54 6)) #b0) ))
				(=> (= #b0 (select T_ROB_busy (_ bv55 6))) (and (= (select T_ROB_op (_ bv55 6)) 0) (= (select T_ROB_destination (_ bv55 6)) 0) (= (select T_ROB_result (_ bv55 6)) 0) (= (select T_ROB_exception (_ bv55 6)) #b0) (= (select T_ROB_done (_ bv55 6)) #b0) ))
				(=> (= #b0 (select T_ROB_busy (_ bv56 6))) (and (= (select T_ROB_op (_ bv56 6)) 0) (= (select T_ROB_destination (_ bv56 6)) 0) (= (select T_ROB_result (_ bv56 6)) 0) (= (select T_ROB_exception (_ bv56 6)) #b0) (= (select T_ROB_done (_ bv56 6)) #b0) ))
				(=> (= #b0 (select T_ROB_busy (_ bv57 6))) (and (= (select T_ROB_op (_ bv57 6)) 0) (= (select T_ROB_destination (_ bv57 6)) 0) (= (select T_ROB_result (_ bv57 6)) 0) (= (select T_ROB_exception (_ bv57 6)) #b0) (= (select T_ROB_done (_ bv57 6)) #b0) ))
				(=> (= #b0 (select T_ROB_busy (_ bv58 6))) (and (= (select T_ROB_op (_ bv58 6)) 0) (= (select T_ROB_destination (_ bv58 6)) 0) (= (select T_ROB_result (_ bv58 6)) 0) (= (select T_ROB_exception (_ bv58 6)) #b0) (= (select T_ROB_done (_ bv58 6)) #b0) ))
				(=> (= #b0 (select T_ROB_busy (_ bv59 6))) (and (= (select T_ROB_op (_ bv59 6)) 0) (= (select T_ROB_destination (_ bv59 6)) 0) (= (select T_ROB_result (_ bv59 6)) 0) (= (select T_ROB_exception (_ bv59 6)) #b0) (= (select T_ROB_done (_ bv59 6)) #b0) ))
				(=> (= #b0 (select T_ROB_busy (_ bv60 6))) (and (= (select T_ROB_op (_ bv60 6)) 0) (= (select T_ROB_destination (_ bv60 6)) 0) (= (select T_ROB_result (_ bv60 6)) 0) (= (select T_ROB_exception (_ bv60 6)) #b0) (= (select T_ROB_done (_ bv60 6)) #b0) ))
				(=> (= #b0 (select T_ROB_busy (_ bv61 6))) (and (= (select T_ROB_op (_ bv61 6)) 0) (= (select T_ROB_destination (_ bv61 6)) 0) (= (select T_ROB_result (_ bv61 6)) 0) (= (select T_ROB_exception (_ bv61 6)) #b0) (= (select T_ROB_done (_ bv61 6)) #b0) ))
				(=> (= #b0 (select T_ROB_busy (_ bv62 6))) (and (= (select T_ROB_op (_ bv62 6)) 0) (= (select T_ROB_destination (_ bv62 6)) 0) (= (select T_ROB_result (_ bv62 6)) 0) (= (select T_ROB_exception (_ bv62 6)) #b0) (= (select T_ROB_done (_ bv62 6)) #b0) ))
				(=> (= #b0 (select T_ROB_busy (_ bv63 6))) (and (= (select T_ROB_op (_ bv63 6)) 0) (= (select T_ROB_destination (_ bv63 6)) 0) (= (select T_ROB_result (_ bv63 6)) 0) (= (select T_ROB_exception (_ bv63 6)) #b0) (= (select T_ROB_done (_ bv63 6)) #b0) ))
;)

	

;(----------------------------General Invarint 4 RS, LSQ ()-------------------------------------------------
				(=> (= #b1 (select T_RS_busy (_ bv0 3))) (and (= (select T_ROB_op (select T_RS_ROB_dst (_ bv0 3))) (select T_RS_op (_ bv0 3))) (= #b1 (select T_ROB_busy (select T_RS_ROB_dst (_ bv0 3)))) (= #b0 (select T_ROB_done (select T_RS_ROB_dst (_ bv0 3))))))
				(=> (= #b1 (select T_RS_busy (_ bv1 3))) (and (= (select T_ROB_op (select T_RS_ROB_dst (_ bv1 3))) (select T_RS_op (_ bv1 3))) (= #b1 (select T_ROB_busy (select T_RS_ROB_dst (_ bv1 3)))) (= #b0 (select T_ROB_done (select T_RS_ROB_dst (_ bv1 3))))))
				(=> (= #b1 (select T_RS_busy (_ bv2 3))) (and (= (select T_ROB_op (select T_RS_ROB_dst (_ bv2 3))) (select T_RS_op (_ bv2 3))) (= #b1 (select T_ROB_busy (select T_RS_ROB_dst (_ bv2 3)))) (= #b0 (select T_ROB_done (select T_RS_ROB_dst (_ bv2 3))))))
				(=> (= #b1 (select T_RS_busy (_ bv3 3))) (and (= (select T_ROB_op (select T_RS_ROB_dst (_ bv3 3))) (select T_RS_op (_ bv3 3))) (= #b1 (select T_ROB_busy (select T_RS_ROB_dst (_ bv3 3)))) (= #b0 (select T_ROB_done (select T_RS_ROB_dst (_ bv3 3))))))
				(=> (= #b1 (select T_RS_busy (_ bv4 3))) (and (= (select T_ROB_op (select T_RS_ROB_dst (_ bv4 3))) (select T_RS_op (_ bv4 3))) (= #b1 (select T_ROB_busy (select T_RS_ROB_dst (_ bv4 3)))) (= #b0 (select T_ROB_done (select T_RS_ROB_dst (_ bv4 3))))))
				(=> (= #b1 (select T_RS_busy (_ bv5 3))) (and (= (select T_ROB_op (select T_RS_ROB_dst (_ bv5 3))) (select T_RS_op (_ bv5 3))) (= #b1 (select T_ROB_busy (select T_RS_ROB_dst (_ bv5 3)))) (= #b0 (select T_ROB_done (select T_RS_ROB_dst (_ bv5 3))))))
				(=> (= #b1 (select T_RS_busy (_ bv6 3))) (and (= (select T_ROB_op (select T_RS_ROB_dst (_ bv6 3))) (select T_RS_op (_ bv6 3))) (= #b1 (select T_ROB_busy (select T_RS_ROB_dst (_ bv6 3)))) (= #b0 (select T_ROB_done (select T_RS_ROB_dst (_ bv6 3))))))
				(=> (= #b1 (select T_RS_busy (_ bv7 3))) (and (= (select T_ROB_op (select T_RS_ROB_dst (_ bv7 3))) (select T_RS_op (_ bv7 3))) (= #b1 (select T_ROB_busy (select T_RS_ROB_dst (_ bv7 3)))) (= #b0 (select T_ROB_done (select T_RS_ROB_dst (_ bv7 3))))))


				(=> (= #b0 (select T_RS_busy (_ bv0 3))) (and (= #b000000 (select T_RS_ROB_dst (_ bv0 3))) (= #b0 (select T_RS_dis (_ bv0 3)))))
				(=> (= #b0 (select T_RS_busy (_ bv1 3))) (and (= #b000000 (select T_RS_ROB_dst (_ bv1 3))) (= #b0 (select T_RS_dis (_ bv1 3)))))
				(=> (= #b0 (select T_RS_busy (_ bv2 3))) (and (= #b000000 (select T_RS_ROB_dst (_ bv2 3))) (= #b0 (select T_RS_dis (_ bv2 3)))))
				(=> (= #b0 (select T_RS_busy (_ bv3 3))) (and (= #b000000 (select T_RS_ROB_dst (_ bv3 3))) (= #b0 (select T_RS_dis (_ bv3 3)))))
				(=> (= #b0 (select T_RS_busy (_ bv4 3))) (and (= #b000000 (select T_RS_ROB_dst (_ bv4 3))) (= #b0 (select T_RS_dis (_ bv4 3)))))
				(=> (= #b0 (select T_RS_busy (_ bv5 3))) (and (= #b000000 (select T_RS_ROB_dst (_ bv5 3))) (= #b0 (select T_RS_dis (_ bv5 3)))))
				(=> (= #b0 (select T_RS_busy (_ bv6 3))) (and (= #b000000 (select T_RS_ROB_dst (_ bv6 3))) (= #b0 (select T_RS_dis (_ bv6 3)))))
				(=> (= #b0 (select T_RS_busy (_ bv7 3))) (and (= #b000000 (select T_RS_ROB_dst (_ bv7 3))) (= #b0 (select T_RS_dis (_ bv7 3)))))

				;; RS Entry 0
                (=> (= #b1 (select T_RS_busy (_ bv0 3))) (and 
                (not (= (select T_RS_ROB_dst (_ bv0 3)) (select T_RS_ROB_dst (_ bv1 3))))
    			(not (= (select T_RS_ROB_dst (_ bv0 3)) (select T_RS_ROB_dst (_ bv2 3))))
    			(not (= (select T_RS_ROB_dst (_ bv0 3)) (select T_RS_ROB_dst (_ bv3 3))))
    			(not (= (select T_RS_ROB_dst (_ bv0 3)) (select T_RS_ROB_dst (_ bv4 3))))
    			(not (= (select T_RS_ROB_dst (_ bv0 3)) (select T_RS_ROB_dst (_ bv5 3))))
    			(not (= (select T_RS_ROB_dst (_ bv0 3)) (select T_RS_ROB_dst (_ bv6 3))))
    			(not (= (select T_RS_ROB_dst (_ bv0 3)) (select T_RS_ROB_dst (_ bv7 3))))
                (not (= (select T_RS_ROB_dst (_ bv0 3)) (select T_LSQ_ROB_dst (_ bv0 4))))
    			(not (= (select T_RS_ROB_dst (_ bv0 3)) (select T_LSQ_ROB_dst (_ bv1 4))))
                (not (= (select T_RS_ROB_dst (_ bv0 3)) (select T_LSQ_ROB_dst (_ bv2 4))))
    			(not (= (select T_RS_ROB_dst (_ bv0 3)) (select T_LSQ_ROB_dst (_ bv3 4))))
    			(not (= (select T_RS_ROB_dst (_ bv0 3)) (select T_LSQ_ROB_dst (_ bv4 4))))
    			(not (= (select T_RS_ROB_dst (_ bv0 3)) (select T_LSQ_ROB_dst (_ bv5 4))))
    			(not (= (select T_RS_ROB_dst (_ bv0 3)) (select T_LSQ_ROB_dst (_ bv6 4))))
    			(not (= (select T_RS_ROB_dst (_ bv0 3)) (select T_LSQ_ROB_dst (_ bv7 4))))
    			(not (= (select T_RS_ROB_dst (_ bv0 3)) (select T_LSQ_ROB_dst (_ bv8 4))))
    			(not (= (select T_RS_ROB_dst (_ bv0 3)) (select T_LSQ_ROB_dst (_ bv9 4))))
    			(not (= (select T_RS_ROB_dst (_ bv0 3)) (select T_LSQ_ROB_dst (_ bv10 4))))
   			    (not (= (select T_RS_ROB_dst (_ bv0 3)) (select T_LSQ_ROB_dst (_ bv11 4))))
                (not (= (select T_RS_ROB_dst (_ bv0 3)) (select T_LSQ_ROB_dst (_ bv12 4))))
                (not (= (select T_RS_ROB_dst (_ bv0 3)) (select T_LSQ_ROB_dst (_ bv13 4))))
   				 (not (= (select T_RS_ROB_dst (_ bv0 3)) (select T_LSQ_ROB_dst (_ bv14 4))))
				 (not (= (select T_RS_ROB_dst (_ bv0 3)) (select T_LSQ_ROB_dst (_ bv15 4)))))) ;done

				;; RS Entry 1
				(=> (= #b1 (select T_RS_busy (_ bv1 3))) (and 
    			(not (= (select T_RS_ROB_dst (_ bv1 3)) (select T_RS_ROB_dst (_ bv0 3))))
    			(not (= (select T_RS_ROB_dst (_ bv1 3)) (select T_RS_ROB_dst (_ bv2 3))))
    			(not (= (select T_RS_ROB_dst (_ bv1 3)) (select T_RS_ROB_dst (_ bv3 3))))
    			(not (= (select T_RS_ROB_dst (_ bv1 3)) (select T_RS_ROB_dst (_ bv4 3))))
    			(not (= (select T_RS_ROB_dst (_ bv1 3)) (select T_RS_ROB_dst (_ bv5 3))))
    			(not (= (select T_RS_ROB_dst (_ bv1 3)) (select T_RS_ROB_dst (_ bv6 3))))
    			(not (= (select T_RS_ROB_dst (_ bv1 3)) (select T_RS_ROB_dst (_ bv7 3))))
    			(not (= (select T_RS_ROB_dst (_ bv1 3)) (select T_LSQ_ROB_dst (_ bv0 4))))
    			(not (= (select T_RS_ROB_dst (_ bv1 3)) (select T_LSQ_ROB_dst (_ bv1 4))))
   			    (not (= (select T_RS_ROB_dst (_ bv1 3)) (select T_LSQ_ROB_dst (_ bv2 4))))
    			(not (= (select T_RS_ROB_dst (_ bv1 3)) (select T_LSQ_ROB_dst (_ bv3 4))))
     			(not (= (select T_RS_ROB_dst (_ bv1 3)) (select T_LSQ_ROB_dst (_ bv4 4))))
    			(not (= (select T_RS_ROB_dst (_ bv1 3)) (select T_LSQ_ROB_dst (_ bv5 4))))
   			    (not (= (select T_RS_ROB_dst (_ bv1 3)) (select T_LSQ_ROB_dst (_ bv6 4))))
    			(not (= (select T_RS_ROB_dst (_ bv1 3)) (select T_LSQ_ROB_dst (_ bv7 4))))
   			    (not (= (select T_RS_ROB_dst (_ bv1 3)) (select T_LSQ_ROB_dst (_ bv8 4))))
    			(not (= (select T_RS_ROB_dst (_ bv1 3)) (select T_LSQ_ROB_dst (_ bv9 4))))
    			(not (= (select T_RS_ROB_dst (_ bv1 3)) (select T_LSQ_ROB_dst (_ bv10 4))))
   				(not (= (select T_RS_ROB_dst (_ bv1 3)) (select T_LSQ_ROB_dst (_ bv11 4))))
				(not (= (select T_RS_ROB_dst (_ bv1 3)) (select T_LSQ_ROB_dst (_ bv12 4))))
				(not (= (select T_RS_ROB_dst (_ bv1 3)) (select T_LSQ_ROB_dst (_ bv13 4))))
				(not (= (select T_RS_ROB_dst (_ bv1 3)) (select T_LSQ_ROB_dst (_ bv14 4))))
				(not (= (select T_RS_ROB_dst (_ bv1 3)) (select T_LSQ_ROB_dst (_ bv15 4)))))) ;done

				;; RS Entry 2
				(=> (= #b1 (select T_RS_busy (_ bv2 3))) (and 
				(not (= (select T_RS_ROB_dst (_ bv2 3)) (select T_RS_ROB_dst (_ bv0 3))))
				(not (= (select T_RS_ROB_dst (_ bv2 3)) (select T_RS_ROB_dst (_ bv1 3))))
				(not (= (select T_RS_ROB_dst (_ bv2 3)) (select T_RS_ROB_dst (_ bv3 3))))
				(not (= (select T_RS_ROB_dst (_ bv2 3)) (select T_RS_ROB_dst (_ bv4 3))))
				(not (= (select T_RS_ROB_dst (_ bv2 3)) (select T_RS_ROB_dst (_ bv5 3))))
				(not (= (select T_RS_ROB_dst (_ bv2 3)) (select T_RS_ROB_dst (_ bv6 3))))
				(not (= (select T_RS_ROB_dst (_ bv2 3)) (select T_RS_ROB_dst (_ bv7 3))))
				(not (= (select T_RS_ROB_dst (_ bv2 3)) (select T_LSQ_ROB_dst (_ bv0 4))))
				(not (= (select T_RS_ROB_dst (_ bv2 3)) (select T_LSQ_ROB_dst (_ bv1 4))))
				(not (= (select T_RS_ROB_dst (_ bv2 3)) (select T_LSQ_ROB_dst (_ bv2 4))))
				(not (= (select T_RS_ROB_dst (_ bv2 3)) (select T_LSQ_ROB_dst (_ bv3 4))))
				(not (= (select T_RS_ROB_dst (_ bv2 3)) (select T_LSQ_ROB_dst (_ bv4 4))))
				(not (= (select T_RS_ROB_dst (_ bv2 3)) (select T_LSQ_ROB_dst (_ bv5 4))))
				(not (= (select T_RS_ROB_dst (_ bv2 3)) (select T_LSQ_ROB_dst (_ bv6 4))))
				(not (= (select T_RS_ROB_dst (_ bv2 3)) (select T_LSQ_ROB_dst (_ bv7 4))))
				(not (= (select T_RS_ROB_dst (_ bv2 3)) (select T_LSQ_ROB_dst (_ bv8 4))))
				(not (= (select T_RS_ROB_dst (_ bv2 3)) (select T_LSQ_ROB_dst (_ bv9 4))))
				(not (= (select T_RS_ROB_dst (_ bv2 3)) (select T_LSQ_ROB_dst (_ bv10 4))))
				(not (= (select T_RS_ROB_dst (_ bv2 3)) (select T_LSQ_ROB_dst (_ bv11 4))))
				(not (= (select T_RS_ROB_dst (_ bv2 3)) (select T_LSQ_ROB_dst (_ bv12 4))))
				(not (= (select T_RS_ROB_dst (_ bv2 3)) (select T_LSQ_ROB_dst (_ bv13 4))))
				(not (= (select T_RS_ROB_dst (_ bv2 3)) (select T_LSQ_ROB_dst (_ bv14 4))))
				(not (= (select T_RS_ROB_dst (_ bv2 3)) (select T_LSQ_ROB_dst (_ bv15 4)))))) ;done

			;; RS Entry 3
			(=> (= #b1 (select T_RS_busy (_ bv3 3))) (and 
				(not (= (select T_RS_ROB_dst (_ bv3 3)) (select T_RS_ROB_dst (_ bv0 3))))
				(not (= (select T_RS_ROB_dst (_ bv3 3)) (select T_RS_ROB_dst (_ bv1 3))))
				(not (= (select T_RS_ROB_dst (_ bv3 3)) (select T_RS_ROB_dst (_ bv2 3))))
				(not (= (select T_RS_ROB_dst (_ bv3 3)) (select T_RS_ROB_dst (_ bv4 3))))
				(not (= (select T_RS_ROB_dst (_ bv3 3)) (select T_RS_ROB_dst (_ bv5 3))))
				(not (= (select T_RS_ROB_dst (_ bv3 3)) (select T_RS_ROB_dst (_ bv6 3))))
				(not (= (select T_RS_ROB_dst (_ bv3 3)) (select T_RS_ROB_dst (_ bv7 3))))
				(not (= (select T_RS_ROB_dst (_ bv3 3)) (select T_LSQ_ROB_dst (_ bv0 4))))
				(not (= (select T_RS_ROB_dst (_ bv3 3)) (select T_LSQ_ROB_dst (_ bv1 4))))
				(not (= (select T_RS_ROB_dst (_ bv3 3)) (select T_LSQ_ROB_dst (_ bv2 4))))
				(not (= (select T_RS_ROB_dst (_ bv3 3)) (select T_LSQ_ROB_dst (_ bv3 4))))
				(not (= (select T_RS_ROB_dst (_ bv3 3)) (select T_LSQ_ROB_dst (_ bv4 4))))
				(not (= (select T_RS_ROB_dst (_ bv3 3)) (select T_LSQ_ROB_dst (_ bv5 4))))
				(not (= (select T_RS_ROB_dst (_ bv3 3)) (select T_LSQ_ROB_dst (_ bv6 4))))
				(not (= (select T_RS_ROB_dst (_ bv3 3)) (select T_LSQ_ROB_dst (_ bv7 4))))
				(not (= (select T_RS_ROB_dst (_ bv3 3)) (select T_LSQ_ROB_dst (_ bv8 4))))
				(not (= (select T_RS_ROB_dst (_ bv3 3)) (select T_LSQ_ROB_dst (_ bv9 4))))
				(not (= (select T_RS_ROB_dst (_ bv3 3)) (select T_LSQ_ROB_dst (_ bv10 4))))
				(not (= (select T_RS_ROB_dst (_ bv3 3)) (select T_LSQ_ROB_dst (_ bv11 4))))
				(not (= (select T_RS_ROB_dst (_ bv3 3)) (select T_LSQ_ROB_dst (_ bv12 4))))
				(not (= (select T_RS_ROB_dst (_ bv3 3)) (select T_LSQ_ROB_dst (_ bv13 4))))
				(not (= (select T_RS_ROB_dst (_ bv3 3)) (select T_LSQ_ROB_dst (_ bv14 4))))
				(not (= (select T_RS_ROB_dst (_ bv3 3)) (select T_LSQ_ROB_dst (_ bv15 4)))))) ;done

				;; RS Entry 4
				(=> (= #b1 (select T_RS_busy (_ bv4 3))) (and 
				(not (= (select T_RS_ROB_dst (_ bv4 3)) (select T_RS_ROB_dst (_ bv0 3))))
				(not (= (select T_RS_ROB_dst (_ bv4 3)) (select T_RS_ROB_dst (_ bv1 3))))
				(not (= (select T_RS_ROB_dst (_ bv4 3)) (select T_RS_ROB_dst (_ bv2 3))))
				(not (= (select T_RS_ROB_dst (_ bv4 3)) (select T_RS_ROB_dst (_ bv3 3))))
				(not (= (select T_RS_ROB_dst (_ bv4 3)) (select T_RS_ROB_dst (_ bv5 3))))
				(not (= (select T_RS_ROB_dst (_ bv4 3)) (select T_RS_ROB_dst (_ bv6 3))))
				(not (= (select T_RS_ROB_dst (_ bv4 3)) (select T_RS_ROB_dst (_ bv7 3))))
				(not (= (select T_RS_ROB_dst (_ bv4 3)) (select T_LSQ_ROB_dst (_ bv1 4))))
				(not (= (select T_RS_ROB_dst (_ bv4 3)) (select T_LSQ_ROB_dst (_ bv2 4))))
				(not (= (select T_RS_ROB_dst (_ bv4 3)) (select T_LSQ_ROB_dst (_ bv3 4))))
				(not (= (select T_RS_ROB_dst (_ bv4 3)) (select T_LSQ_ROB_dst (_ bv4 4))))
				(not (= (select T_RS_ROB_dst (_ bv4 3)) (select T_LSQ_ROB_dst (_ bv5 4))))
				(not (= (select T_RS_ROB_dst (_ bv4 3)) (select T_LSQ_ROB_dst (_ bv6 4))))
				(not (= (select T_RS_ROB_dst (_ bv4 3)) (select T_LSQ_ROB_dst (_ bv7 4))))
				(not (= (select T_RS_ROB_dst (_ bv4 3)) (select T_LSQ_ROB_dst (_ bv8 4))))
				(not (= (select T_RS_ROB_dst (_ bv4 3)) (select T_LSQ_ROB_dst (_ bv9 4))))
				(not (= (select T_RS_ROB_dst (_ bv4 3)) (select T_LSQ_ROB_dst (_ bv10 4))))
				(not (= (select T_RS_ROB_dst (_ bv4 3)) (select T_LSQ_ROB_dst (_ bv11 4))))
				(not (= (select T_RS_ROB_dst (_ bv4 3)) (select T_LSQ_ROB_dst (_ bv12 4))))
				(not (= (select T_RS_ROB_dst (_ bv4 3)) (select T_LSQ_ROB_dst (_ bv13 4))))
				(not (= (select T_RS_ROB_dst (_ bv4 3)) (select T_LSQ_ROB_dst (_ bv14 4))))
				(not (= (select T_RS_ROB_dst (_ bv4 3)) (select T_LSQ_ROB_dst (_ bv15 4)))))) ;done


					;; RS Entry 5
				(=> (= #b1 (select T_RS_busy (_ bv5 3))) (and 
				(not (= (select T_RS_ROB_dst (_ bv5 3)) (select T_RS_ROB_dst (_ bv0 3))))
				(not (= (select T_RS_ROB_dst (_ bv5 3)) (select T_RS_ROB_dst (_ bv1 3))))
				(not (= (select T_RS_ROB_dst (_ bv5 3)) (select T_RS_ROB_dst (_ bv2 3))))
				(not (= (select T_RS_ROB_dst (_ bv5 3)) (select T_RS_ROB_dst (_ bv3 3))))
				(not (= (select T_RS_ROB_dst (_ bv5 3)) (select T_RS_ROB_dst (_ bv4 3))))
				(not (= (select T_RS_ROB_dst (_ bv5 3)) (select T_RS_ROB_dst (_ bv6 3))))
				(not (= (select T_RS_ROB_dst (_ bv5 3)) (select T_RS_ROB_dst (_ bv7 3))))
				(not (= (select T_RS_ROB_dst (_ bv5 3)) (select T_LSQ_ROB_dst (_ bv0 4))))
				(not (= (select T_RS_ROB_dst (_ bv5 3)) (select T_LSQ_ROB_dst (_ bv1 4))))
				(not (= (select T_RS_ROB_dst (_ bv5 3)) (select T_LSQ_ROB_dst (_ bv2 4))))
				(not (= (select T_RS_ROB_dst (_ bv5 3)) (select T_LSQ_ROB_dst (_ bv3 4))))
				(not (= (select T_RS_ROB_dst (_ bv5 3)) (select T_LSQ_ROB_dst (_ bv4 4))))
				(not (= (select T_RS_ROB_dst (_ bv5 3)) (select T_LSQ_ROB_dst (_ bv5 4))))
				(not (= (select T_RS_ROB_dst (_ bv5 3)) (select T_LSQ_ROB_dst (_ bv6 4))))
				(not (= (select T_RS_ROB_dst (_ bv5 3)) (select T_LSQ_ROB_dst (_ bv7 4))))
				(not (= (select T_RS_ROB_dst (_ bv5 3)) (select T_LSQ_ROB_dst (_ bv8 4))))
				(not (= (select T_RS_ROB_dst (_ bv5 3)) (select T_LSQ_ROB_dst (_ bv9 4))))
				(not (= (select T_RS_ROB_dst (_ bv5 3)) (select T_LSQ_ROB_dst (_ bv10 4))))
				(not (= (select T_RS_ROB_dst (_ bv5 3)) (select T_LSQ_ROB_dst (_ bv11 4))))
				(not (= (select T_RS_ROB_dst (_ bv5 3)) (select T_LSQ_ROB_dst (_ bv12 4))))
				(not (= (select T_RS_ROB_dst (_ bv5 3)) (select T_LSQ_ROB_dst (_ bv13 4))))
				(not (= (select T_RS_ROB_dst (_ bv5 3)) (select T_LSQ_ROB_dst (_ bv14 4))))
				(not (= (select T_RS_ROB_dst (_ bv5 3)) (select T_LSQ_ROB_dst (_ bv15 4)))))) ;done

					;; RS Entry 6
				(=> (= #b1 (select T_RS_busy (_ bv6 3))) (and 
				(not (= (select T_RS_ROB_dst (_ bv6 3)) (select T_RS_ROB_dst (_ bv0 3))))
				(not (= (select T_RS_ROB_dst (_ bv6 3)) (select T_RS_ROB_dst (_ bv1 3))))
				(not (= (select T_RS_ROB_dst (_ bv6 3)) (select T_RS_ROB_dst (_ bv2 3))))
				(not (= (select T_RS_ROB_dst (_ bv6 3)) (select T_RS_ROB_dst (_ bv3 3))))
				(not (= (select T_RS_ROB_dst (_ bv6 3)) (select T_RS_ROB_dst (_ bv4 3))))
				(not (= (select T_RS_ROB_dst (_ bv6 3)) (select T_RS_ROB_dst (_ bv5 3))))
				(not (= (select T_RS_ROB_dst (_ bv6 3)) (select T_RS_ROB_dst (_ bv7 3))))
				(not (= (select T_RS_ROB_dst (_ bv6 3)) (select T_LSQ_ROB_dst (_ bv0 4))))
				(not (= (select T_RS_ROB_dst (_ bv6 3)) (select T_LSQ_ROB_dst (_ bv1 4))))
				(not (= (select T_RS_ROB_dst (_ bv6 3)) (select T_LSQ_ROB_dst (_ bv2 4))))
				(not (= (select T_RS_ROB_dst (_ bv6 3)) (select T_LSQ_ROB_dst (_ bv3 4))))
				(not (= (select T_RS_ROB_dst (_ bv6 3)) (select T_LSQ_ROB_dst (_ bv4 4))))
				(not (= (select T_RS_ROB_dst (_ bv6 3)) (select T_LSQ_ROB_dst (_ bv5 4))))
				(not (= (select T_RS_ROB_dst (_ bv6 3)) (select T_LSQ_ROB_dst (_ bv6 4))))
				(not (= (select T_RS_ROB_dst (_ bv6 3)) (select T_LSQ_ROB_dst (_ bv7 4))))
				(not (= (select T_RS_ROB_dst (_ bv6 3)) (select T_LSQ_ROB_dst (_ bv8 4))))
				(not (= (select T_RS_ROB_dst (_ bv6 3)) (select T_LSQ_ROB_dst (_ bv9 4))))
				(not (= (select T_RS_ROB_dst (_ bv6 3)) (select T_LSQ_ROB_dst (_ bv10 4))))
				(not (= (select T_RS_ROB_dst (_ bv6 3)) (select T_LSQ_ROB_dst (_ bv11 4))))
				(not (= (select T_RS_ROB_dst (_ bv6 3)) (select T_LSQ_ROB_dst (_ bv12 4))))
				(not (= (select T_RS_ROB_dst (_ bv6 3)) (select T_LSQ_ROB_dst (_ bv13 4))))
				(not (= (select T_RS_ROB_dst (_ bv6 3)) (select T_LSQ_ROB_dst (_ bv14 4))))
				(not (= (select T_RS_ROB_dst (_ bv6 3)) (select T_LSQ_ROB_dst (_ bv15 4)))))) ;done

					;; RS Entry 7
				(=> (= #b1 (select T_RS_busy (_ bv7 3))) (and 
				(not (= (select T_RS_ROB_dst (_ bv7 3)) (select T_RS_ROB_dst (_ bv0 3))))
				(not (= (select T_RS_ROB_dst (_ bv7 3)) (select T_RS_ROB_dst (_ bv1 3))))
				(not (= (select T_RS_ROB_dst (_ bv7 3)) (select T_RS_ROB_dst (_ bv2 3))))
				(not (= (select T_RS_ROB_dst (_ bv7 3)) (select T_RS_ROB_dst (_ bv3 3))))
				(not (= (select T_RS_ROB_dst (_ bv7 3)) (select T_RS_ROB_dst (_ bv4 3))))
				(not (= (select T_RS_ROB_dst (_ bv7 3)) (select T_RS_ROB_dst (_ bv5 3))))
				(not (= (select T_RS_ROB_dst (_ bv7 3)) (select T_RS_ROB_dst (_ bv6 3))))
				(not (= (select T_RS_ROB_dst (_ bv7 3)) (select T_LSQ_ROB_dst (_ bv0 4))))
				(not (= (select T_RS_ROB_dst (_ bv7 3)) (select T_LSQ_ROB_dst (_ bv1 4))))
				(not (= (select T_RS_ROB_dst (_ bv7 3)) (select T_LSQ_ROB_dst (_ bv2 4))))
				(not (= (select T_RS_ROB_dst (_ bv7 3)) (select T_LSQ_ROB_dst (_ bv3 4))))
				(not (= (select T_RS_ROB_dst (_ bv7 3)) (select T_LSQ_ROB_dst (_ bv4 4))))
				(not (= (select T_RS_ROB_dst (_ bv7 3)) (select T_LSQ_ROB_dst (_ bv5 4))))
				(not (= (select T_RS_ROB_dst (_ bv7 3)) (select T_LSQ_ROB_dst (_ bv6 4))))
				(not (= (select T_RS_ROB_dst (_ bv7 3)) (select T_LSQ_ROB_dst (_ bv7 4))))
				(not (= (select T_RS_ROB_dst (_ bv7 3)) (select T_LSQ_ROB_dst (_ bv8 4))))
				(not (= (select T_RS_ROB_dst (_ bv7 3)) (select T_LSQ_ROB_dst (_ bv9 4))))
				(not (= (select T_RS_ROB_dst (_ bv7 3)) (select T_LSQ_ROB_dst (_ bv10 4))))
				(not (= (select T_RS_ROB_dst (_ bv7 3)) (select T_LSQ_ROB_dst (_ bv11 4))))
				(not (= (select T_RS_ROB_dst (_ bv7 3)) (select T_LSQ_ROB_dst (_ bv12 4))))
				(not (= (select T_RS_ROB_dst (_ bv7 3)) (select T_LSQ_ROB_dst (_ bv13 4))))
				(not (= (select T_RS_ROB_dst (_ bv7 3)) (select T_LSQ_ROB_dst (_ bv14 4))))
				(not (= (select T_RS_ROB_dst (_ bv7 3)) (select T_LSQ_ROB_dst (_ bv15 4)))))) ;done


				(=> (= #b1 (select T_LSQ_busy (_ bv0 4))) (and (= (select T_ROB_op (select T_LSQ_ROB_dst (_ bv0 4))) (select T_LSQ_op (_ bv0 4))) (= #b1 (select T_ROB_busy (select T_LSQ_ROB_dst (_ bv0 4)))) (= #b0 (select T_ROB_done (select T_LSQ_ROB_dst (_ bv0 4))))))
				(=> (= #b1 (select T_LSQ_busy (_ bv1 4))) (and (= (select T_ROB_op (select T_LSQ_ROB_dst (_ bv1 4))) (select T_LSQ_op (_ bv1 4))) (= #b1 (select T_ROB_busy (select T_LSQ_ROB_dst (_ bv1 4)))) (= #b0 (select T_ROB_done (select T_LSQ_ROB_dst (_ bv1 4))))))
				(=> (= #b1 (select T_LSQ_busy (_ bv2 4))) (and (= (select T_ROB_op (select T_LSQ_ROB_dst (_ bv2 4))) (select T_LSQ_op (_ bv2 4))) (= #b1 (select T_ROB_busy (select T_LSQ_ROB_dst (_ bv2 4)))) (= #b0 (select T_ROB_done (select T_LSQ_ROB_dst (_ bv2 4))))))
				(=> (= #b1 (select T_LSQ_busy (_ bv3 4))) (and (= (select T_ROB_op (select T_LSQ_ROB_dst (_ bv3 4))) (select T_LSQ_op (_ bv3 4))) (= #b1 (select T_ROB_busy (select T_LSQ_ROB_dst (_ bv3 4)))) (= #b0 (select T_ROB_done (select T_LSQ_ROB_dst (_ bv3 4))))))
                (=> (= #b1 (select T_LSQ_busy (_ bv4 4))) (and (= (select T_ROB_op (select T_LSQ_ROB_dst (_ bv4 4))) (select T_LSQ_op (_ bv4 4))) (= #b1 (select T_ROB_busy (select T_LSQ_ROB_dst (_ bv4 4)))) (= #b0 (select T_ROB_done (select T_LSQ_ROB_dst (_ bv4 4))))))
				(=> (= #b1 (select T_LSQ_busy (_ bv5 4))) (and (= (select T_ROB_op (select T_LSQ_ROB_dst (_ bv5 4))) (select T_LSQ_op (_ bv5 4))) (= #b1 (select T_ROB_busy (select T_LSQ_ROB_dst (_ bv5 4)))) (= #b0 (select T_ROB_done (select T_LSQ_ROB_dst (_ bv5 4))))))
				(=> (= #b1 (select T_LSQ_busy (_ bv6 4))) (and (= (select T_ROB_op (select T_LSQ_ROB_dst (_ bv6 4))) (select T_LSQ_op (_ bv6 4))) (= #b1 (select T_ROB_busy (select T_LSQ_ROB_dst (_ bv6 4)))) (= #b0 (select T_ROB_done (select T_LSQ_ROB_dst (_ bv6 4))))))
				(=> (= #b1 (select T_LSQ_busy (_ bv7 4))) (and (= (select T_ROB_op (select T_LSQ_ROB_dst (_ bv7 4))) (select T_LSQ_op (_ bv7 4))) (= #b1 (select T_ROB_busy (select T_LSQ_ROB_dst (_ bv7 4)))) (= #b0 (select T_ROB_done (select T_LSQ_ROB_dst (_ bv7 4))))))
				(=> (= #b1 (select T_LSQ_busy (_ bv8 4))) (and (= (select T_ROB_op (select T_LSQ_ROB_dst (_ bv8 4))) (select T_LSQ_op (_ bv8 4))) (= #b1 (select T_ROB_busy (select T_LSQ_ROB_dst (_ bv8 4)))) (= #b0 (select T_ROB_done (select T_LSQ_ROB_dst (_ bv8 4))))))
				(=> (= #b1 (select T_LSQ_busy (_ bv9 4))) (and (= (select T_ROB_op (select T_LSQ_ROB_dst (_ bv9 4))) (select T_LSQ_op (_ bv9 4))) (= #b1 (select T_ROB_busy (select T_LSQ_ROB_dst (_ bv9 4)))) (= #b0 (select T_ROB_done (select T_LSQ_ROB_dst (_ bv9 4))))))
				(=> (= #b1 (select T_LSQ_busy (_ bv10 4))) (and (= (select T_ROB_op (select T_LSQ_ROB_dst (_ bv10 4))) (select T_LSQ_op (_ bv10 4))) (= #b1 (select T_ROB_busy (select T_LSQ_ROB_dst (_ bv10 4)))) (= #b0 (select T_ROB_done (select T_LSQ_ROB_dst (_ bv10 4))))))
				(=> (= #b1 (select T_LSQ_busy (_ bv11 4))) (and (= (select T_ROB_op (select T_LSQ_ROB_dst (_ bv11 4))) (select T_LSQ_op (_ bv11 4))) (= #b1 (select T_ROB_busy (select T_LSQ_ROB_dst (_ bv11 4)))) (= #b0 (select T_ROB_done (select T_LSQ_ROB_dst (_ bv11 4))))))
                (=> (= #b1 (select T_LSQ_busy (_ bv12 4))) (and (= (select T_ROB_op (select T_LSQ_ROB_dst (_ bv12 4))) (select T_LSQ_op (_ bv12 4))) (= #b1 (select T_ROB_busy (select T_LSQ_ROB_dst (_ bv12 4)))) (= #b0 (select T_ROB_done (select T_LSQ_ROB_dst (_ bv12 4))))))
				(=> (= #b1 (select T_LSQ_busy (_ bv13 4))) (and (= (select T_ROB_op (select T_LSQ_ROB_dst (_ bv13 4))) (select T_LSQ_op (_ bv13 4))) (= #b1 (select T_ROB_busy (select T_LSQ_ROB_dst (_ bv13 4)))) (= #b0 (select T_ROB_done (select T_LSQ_ROB_dst (_ bv13 4))))))
				(=> (= #b1 (select T_LSQ_busy (_ bv14 4))) (and (= (select T_ROB_op (select T_LSQ_ROB_dst (_ bv14 4))) (select T_LSQ_op (_ bv14 4))) (= #b1 (select T_ROB_busy (select T_LSQ_ROB_dst (_ bv14 4)))) (= #b0 (select T_ROB_done (select T_LSQ_ROB_dst (_ bv14 4))))))
				(=> (= #b1 (select T_LSQ_busy (_ bv15 4))) (and (= (select T_ROB_op (select T_LSQ_ROB_dst (_ bv15 4))) (select T_LSQ_op (_ bv15 4))) (= #b1 (select T_ROB_busy (select T_LSQ_ROB_dst (_ bv15 4)))) (= #b0 (select T_ROB_done (select T_LSQ_ROB_dst (_ bv15 4))))))

				(=> (= #b0 (select T_LSQ_busy (_ bv0 4))) (and (= #b000000 (select T_LSQ_ROB_dst (_ bv0 4))) (= #b0 (select T_LSQ_dis (_ bv0 4)))))
				(=> (= #b0 (select T_LSQ_busy (_ bv1 4))) (and (= #b000000 (select T_LSQ_ROB_dst (_ bv1 4))) (= #b0 (select T_LSQ_dis (_ bv1 4)))))
				(=> (= #b0 (select T_LSQ_busy (_ bv2 4))) (and (= #b000000 (select T_LSQ_ROB_dst (_ bv2 4))) (= #b0 (select T_LSQ_dis (_ bv2 4)))))
				(=> (= #b0 (select T_LSQ_busy (_ bv3 4))) (and (= #b000000 (select T_LSQ_ROB_dst (_ bv3 4))) (= #b0 (select T_LSQ_dis (_ bv3 4)))))
                (=> (= #b0 (select T_LSQ_busy (_ bv4 4))) (and (= #b000000 (select T_LSQ_ROB_dst (_ bv4 4))) (= #b0 (select T_LSQ_dis (_ bv4 4)))))
				(=> (= #b0 (select T_LSQ_busy (_ bv5 4))) (and (= #b000000 (select T_LSQ_ROB_dst (_ bv5 4))) (= #b0 (select T_LSQ_dis (_ bv5 4)))))
				(=> (= #b0 (select T_LSQ_busy (_ bv6 4))) (and (= #b000000 (select T_LSQ_ROB_dst (_ bv6 4))) (= #b0 (select T_LSQ_dis (_ bv6 4)))))
				(=> (= #b0 (select T_LSQ_busy (_ bv7 4))) (and (= #b000000 (select T_LSQ_ROB_dst (_ bv7 4))) (= #b0 (select T_LSQ_dis (_ bv7 4)))))
				(=> (= #b0 (select T_LSQ_busy (_ bv8 4))) (and (= #b000000 (select T_LSQ_ROB_dst (_ bv8 4))) (= #b0 (select T_LSQ_dis (_ bv8 4)))))
				(=> (= #b0 (select T_LSQ_busy (_ bv9 4))) (and (= #b000000 (select T_LSQ_ROB_dst (_ bv9 4))) (= #b0 (select T_LSQ_dis (_ bv9 4)))))
				(=> (= #b0 (select T_LSQ_busy (_ bv10 4))) (and (= #b000000 (select T_LSQ_ROB_dst (_ bv10 4))) (= #b0 (select T_LSQ_dis (_ bv10 4)))))
				(=> (= #b0 (select T_LSQ_busy (_ bv11 4))) (and (= #b000000 (select T_LSQ_ROB_dst (_ bv11 4))) (= #b0 (select T_LSQ_dis (_ bv11 4)))))
                (=> (= #b0 (select T_LSQ_busy (_ bv12 4))) (and (= #b000000 (select T_LSQ_ROB_dst (_ bv12 4))) (= #b0 (select T_LSQ_dis (_ bv12 4)))))
				(=> (= #b0 (select T_LSQ_busy (_ bv13 4))) (and (= #b000000 (select T_LSQ_ROB_dst (_ bv13 4))) (= #b0 (select T_LSQ_dis (_ bv13 4)))))
				(=> (= #b0 (select T_LSQ_busy (_ bv14 4))) (and (= #b000000 (select T_LSQ_ROB_dst (_ bv14 4))) (= #b0 (select T_LSQ_dis (_ bv14 4)))))
				(=> (= #b0 (select T_LSQ_busy (_ bv15 4))) (and (= #b000000 (select T_LSQ_ROB_dst (_ bv15 4))) (= #b0 (select T_LSQ_dis (_ bv15 4)))))

   ;; LSQ Entry 0
				(=> (= #b1 (select T_LSQ_busy (_ bv0 4))) (and 
					(not (= (select T_LSQ_ROB_dst (_ bv0 4)) (select T_LSQ_ROB_dst (_ bv1 4))))
					(not (= (select T_LSQ_ROB_dst (_ bv0 4)) (select T_LSQ_ROB_dst (_ bv2 4))))
					(not (= (select T_LSQ_ROB_dst (_ bv0 4)) (select T_LSQ_ROB_dst (_ bv3 4))))
					(not (= (select T_LSQ_ROB_dst (_ bv0 4)) (select T_LSQ_ROB_dst (_ bv4 4))))
					(not (= (select T_LSQ_ROB_dst (_ bv0 4)) (select T_LSQ_ROB_dst (_ bv5 4))))
					(not (= (select T_LSQ_ROB_dst (_ bv0 4)) (select T_LSQ_ROB_dst (_ bv6 4))))
					(not (= (select T_LSQ_ROB_dst (_ bv0 4)) (select T_LSQ_ROB_dst (_ bv7 4))))
					(not (= (select T_LSQ_ROB_dst (_ bv0 4)) (select T_LSQ_ROB_dst (_ bv8 4))))
					(not (= (select T_LSQ_ROB_dst (_ bv0 4)) (select T_LSQ_ROB_dst (_ bv9 4))))
					(not (= (select T_LSQ_ROB_dst (_ bv0 4)) (select T_LSQ_ROB_dst (_ bv10 4))))
					(not (= (select T_LSQ_ROB_dst (_ bv0 4)) (select T_LSQ_ROB_dst (_ bv11 4))))
					(not (= (select T_LSQ_ROB_dst (_ bv0 4)) (select T_LSQ_ROB_dst (_ bv12 4))))
					(not (= (select T_LSQ_ROB_dst (_ bv0 4)) (select T_LSQ_ROB_dst (_ bv13 4))))
					(not (= (select T_LSQ_ROB_dst (_ bv0 4)) (select T_LSQ_ROB_dst (_ bv14 4))))
					(not (= (select T_LSQ_ROB_dst (_ bv0 4)) (select T_LSQ_ROB_dst (_ bv15 4))))
					(not (= (select T_LSQ_ROB_dst (_ bv0 4)) (select T_RS_ROB_dst (_ bv0 3))))
					(not (= (select T_LSQ_ROB_dst (_ bv0 4)) (select T_RS_ROB_dst (_ bv1 3))))
					(not (= (select T_LSQ_ROB_dst (_ bv0 4)) (select T_RS_ROB_dst (_ bv2 3))))
					(not (= (select T_LSQ_ROB_dst (_ bv0 4)) (select T_RS_ROB_dst (_ bv3 3))))
					(not (= (select T_LSQ_ROB_dst (_ bv0 4)) (select T_RS_ROB_dst (_ bv4 3))))
					(not (= (select T_LSQ_ROB_dst (_ bv0 4)) (select T_RS_ROB_dst (_ bv5 3))))
					(not (= (select T_LSQ_ROB_dst (_ bv0 4)) (select T_RS_ROB_dst (_ bv6 3))))
					(not (= (select T_LSQ_ROB_dst (_ bv0 4)) (select T_RS_ROB_dst (_ bv7 3)))))) ;done

				;; LSQ Entry 1
				(=> (= #b1 (select T_LSQ_busy (_ bv1 4))) (and 
					(not (= (select T_LSQ_ROB_dst (_ bv1 4)) (select T_LSQ_ROB_dst (_ bv0 4))))
					(not (= (select T_LSQ_ROB_dst (_ bv1 4)) (select T_LSQ_ROB_dst (_ bv2 4))))
					(not (= (select T_LSQ_ROB_dst (_ bv1 4)) (select T_LSQ_ROB_dst (_ bv3 4))))
					(not (= (select T_LSQ_ROB_dst (_ bv1 4)) (select T_LSQ_ROB_dst (_ bv4 4))))
					(not (= (select T_LSQ_ROB_dst (_ bv1 4)) (select T_LSQ_ROB_dst (_ bv5 4))))
					(not (= (select T_LSQ_ROB_dst (_ bv1 4)) (select T_LSQ_ROB_dst (_ bv6 4))))
					(not (= (select T_LSQ_ROB_dst (_ bv1 4)) (select T_LSQ_ROB_dst (_ bv7 4))))
					(not (= (select T_LSQ_ROB_dst (_ bv1 4)) (select T_LSQ_ROB_dst (_ bv8 4))))
					(not (= (select T_LSQ_ROB_dst (_ bv1 4)) (select T_LSQ_ROB_dst (_ bv9 4))))
					(not (= (select T_LSQ_ROB_dst (_ bv1 4)) (select T_LSQ_ROB_dst (_ bv10 4))))
					(not (= (select T_LSQ_ROB_dst (_ bv1 4)) (select T_LSQ_ROB_dst (_ bv11 4))))
					(not (= (select T_LSQ_ROB_dst (_ bv1 4)) (select T_LSQ_ROB_dst (_ bv12 4))))
					(not (= (select T_LSQ_ROB_dst (_ bv1 4)) (select T_LSQ_ROB_dst (_ bv13 4))))
					(not (= (select T_LSQ_ROB_dst (_ bv1 4)) (select T_LSQ_ROB_dst (_ bv14 4))))
					(not (= (select T_LSQ_ROB_dst (_ bv1 4)) (select T_LSQ_ROB_dst (_ bv15 4))))
					(not (= (select T_LSQ_ROB_dst (_ bv1 4)) (select T_RS_ROB_dst (_ bv0 3))))
					(not (= (select T_LSQ_ROB_dst (_ bv1 4)) (select T_RS_ROB_dst (_ bv1 3))))
					(not (= (select T_LSQ_ROB_dst (_ bv1 4)) (select T_RS_ROB_dst (_ bv2 3))))
					(not (= (select T_LSQ_ROB_dst (_ bv1 4)) (select T_RS_ROB_dst (_ bv3 3))))
					(not (= (select T_LSQ_ROB_dst (_ bv1 4)) (select T_RS_ROB_dst (_ bv4 3))))
					(not (= (select T_LSQ_ROB_dst (_ bv1 4)) (select T_RS_ROB_dst (_ bv5 3))))
					(not (= (select T_LSQ_ROB_dst (_ bv1 4)) (select T_RS_ROB_dst (_ bv6 3))))
					(not (= (select T_LSQ_ROB_dst (_ bv1 4)) (select T_RS_ROB_dst (_ bv7 3)))))) ;done


				;; LSQ Entry 2
				(=> (= #b1 (select T_LSQ_busy (_ bv2 4))) (and 
					(not (= (select T_LSQ_ROB_dst (_ bv2 4)) (select T_LSQ_ROB_dst (_ bv0 4))))
					(not (= (select T_LSQ_ROB_dst (_ bv2 4)) (select T_LSQ_ROB_dst (_ bv1 4))))
					(not (= (select T_LSQ_ROB_dst (_ bv2 4)) (select T_LSQ_ROB_dst (_ bv3 4))))
					(not (= (select T_LSQ_ROB_dst (_ bv2 4)) (select T_LSQ_ROB_dst (_ bv4 4))))
					(not (= (select T_LSQ_ROB_dst (_ bv2 4)) (select T_LSQ_ROB_dst (_ bv5 4))))
					(not (= (select T_LSQ_ROB_dst (_ bv2 4)) (select T_LSQ_ROB_dst (_ bv6 4))))
					(not (= (select T_LSQ_ROB_dst (_ bv2 4)) (select T_LSQ_ROB_dst (_ bv7 4))))
					(not (= (select T_LSQ_ROB_dst (_ bv2 4)) (select T_LSQ_ROB_dst (_ bv8 4))))
					(not (= (select T_LSQ_ROB_dst (_ bv2 4)) (select T_LSQ_ROB_dst (_ bv9 4))))
					(not (= (select T_LSQ_ROB_dst (_ bv2 4)) (select T_LSQ_ROB_dst (_ bv10 4))))
					(not (= (select T_LSQ_ROB_dst (_ bv2 4)) (select T_LSQ_ROB_dst (_ bv11 4))))
					(not (= (select T_LSQ_ROB_dst (_ bv2 4)) (select T_LSQ_ROB_dst (_ bv12 4))))
					(not (= (select T_LSQ_ROB_dst (_ bv2 4)) (select T_LSQ_ROB_dst (_ bv13 4))))
					(not (= (select T_LSQ_ROB_dst (_ bv2 4)) (select T_LSQ_ROB_dst (_ bv14 4))))
					(not (= (select T_LSQ_ROB_dst (_ bv2 4)) (select T_LSQ_ROB_dst (_ bv15 4))))
					(not (= (select T_LSQ_ROB_dst (_ bv2 4)) (select T_RS_ROB_dst (_ bv0 3))))
					(not (= (select T_LSQ_ROB_dst (_ bv2 4)) (select T_RS_ROB_dst (_ bv1 3))))
					(not (= (select T_LSQ_ROB_dst (_ bv2 4)) (select T_RS_ROB_dst (_ bv2 3))))
					(not (= (select T_LSQ_ROB_dst (_ bv2 4)) (select T_RS_ROB_dst (_ bv3 3))))
					(not (= (select T_LSQ_ROB_dst (_ bv2 4)) (select T_RS_ROB_dst (_ bv4 3))))
					(not (= (select T_LSQ_ROB_dst (_ bv2 4)) (select T_RS_ROB_dst (_ bv5 3))))
					(not (= (select T_LSQ_ROB_dst (_ bv2 4)) (select T_RS_ROB_dst (_ bv6 3))))
					(not (= (select T_LSQ_ROB_dst (_ bv2 4)) (select T_RS_ROB_dst (_ bv7 3)))))) ;done

				;; LSQ Entry 3
				(=> (= #b1 (select T_LSQ_busy (_ bv3 4))) (and 
					(not (= (select T_LSQ_ROB_dst (_ bv3 4)) (select T_LSQ_ROB_dst (_ bv0 4))))
					(not (= (select T_LSQ_ROB_dst (_ bv3 4)) (select T_LSQ_ROB_dst (_ bv1 4))))
					(not (= (select T_LSQ_ROB_dst (_ bv3 4)) (select T_LSQ_ROB_dst (_ bv2 4))))
					(not (= (select T_LSQ_ROB_dst (_ bv3 4)) (select T_LSQ_ROB_dst (_ bv4 4))))
					(not (= (select T_LSQ_ROB_dst (_ bv3 4)) (select T_LSQ_ROB_dst (_ bv5 4))))
					(not (= (select T_LSQ_ROB_dst (_ bv3 4)) (select T_LSQ_ROB_dst (_ bv6 4))))
					(not (= (select T_LSQ_ROB_dst (_ bv3 4)) (select T_LSQ_ROB_dst (_ bv7 4))))
					(not (= (select T_LSQ_ROB_dst (_ bv3 4)) (select T_LSQ_ROB_dst (_ bv8 4))))
					(not (= (select T_LSQ_ROB_dst (_ bv3 4)) (select T_LSQ_ROB_dst (_ bv9 4))))
					(not (= (select T_LSQ_ROB_dst (_ bv3 4)) (select T_LSQ_ROB_dst (_ bv10 4))))
					(not (= (select T_LSQ_ROB_dst (_ bv3 4)) (select T_LSQ_ROB_dst (_ bv11 4))))
					(not (= (select T_LSQ_ROB_dst (_ bv3 4)) (select T_LSQ_ROB_dst (_ bv12 4))))
					(not (= (select T_LSQ_ROB_dst (_ bv3 4)) (select T_LSQ_ROB_dst (_ bv13 4))))
					(not (= (select T_LSQ_ROB_dst (_ bv3 4)) (select T_LSQ_ROB_dst (_ bv14 4))))
					(not (= (select T_LSQ_ROB_dst (_ bv3 4)) (select T_LSQ_ROB_dst (_ bv15 4))))
					(not (= (select T_LSQ_ROB_dst (_ bv3 4)) (select T_RS_ROB_dst (_ bv0 3))))
					(not (= (select T_LSQ_ROB_dst (_ bv3 4)) (select T_RS_ROB_dst (_ bv1 3))))
					(not (= (select T_LSQ_ROB_dst (_ bv3 4)) (select T_RS_ROB_dst (_ bv2 3))))
					(not (= (select T_LSQ_ROB_dst (_ bv3 4)) (select T_RS_ROB_dst (_ bv3 3))))
					(not (= (select T_LSQ_ROB_dst (_ bv3 4)) (select T_RS_ROB_dst (_ bv4 3))))
					(not (= (select T_LSQ_ROB_dst (_ bv3 4)) (select T_RS_ROB_dst (_ bv5 3))))
					(not (= (select T_LSQ_ROB_dst (_ bv3 4)) (select T_RS_ROB_dst (_ bv6 3))))
					(not (= (select T_LSQ_ROB_dst (_ bv3 4)) (select T_RS_ROB_dst (_ bv7 3)))))) ;done

				;; LSQ Entry 4
				(=> (= #b1 (select T_LSQ_busy (_ bv4 4))) (and 
					(not (= (select T_LSQ_ROB_dst (_ bv4 4)) (select T_LSQ_ROB_dst (_ bv0 4))))
					(not (= (select T_LSQ_ROB_dst (_ bv4 4)) (select T_LSQ_ROB_dst (_ bv1 4))))
					(not (= (select T_LSQ_ROB_dst (_ bv4 4)) (select T_LSQ_ROB_dst (_ bv2 4))))
					(not (= (select T_LSQ_ROB_dst (_ bv4 4)) (select T_LSQ_ROB_dst (_ bv3 4))))
					(not (= (select T_LSQ_ROB_dst (_ bv4 4)) (select T_LSQ_ROB_dst (_ bv5 4))))
					(not (= (select T_LSQ_ROB_dst (_ bv4 4)) (select T_LSQ_ROB_dst (_ bv6 4))))
					(not (= (select T_LSQ_ROB_dst (_ bv4 4)) (select T_LSQ_ROB_dst (_ bv7 4))))
					(not (= (select T_LSQ_ROB_dst (_ bv4 4)) (select T_LSQ_ROB_dst (_ bv8 4))))
					(not (= (select T_LSQ_ROB_dst (_ bv4 4)) (select T_LSQ_ROB_dst (_ bv9 4))))
					(not (= (select T_LSQ_ROB_dst (_ bv4 4)) (select T_LSQ_ROB_dst (_ bv10 4))))
					(not (= (select T_LSQ_ROB_dst (_ bv4 4)) (select T_LSQ_ROB_dst (_ bv11 4))))
					(not (= (select T_LSQ_ROB_dst (_ bv4 4)) (select T_LSQ_ROB_dst (_ bv12 4))))
					(not (= (select T_LSQ_ROB_dst (_ bv4 4)) (select T_LSQ_ROB_dst (_ bv13 4))))
					(not (= (select T_LSQ_ROB_dst (_ bv4 4)) (select T_LSQ_ROB_dst (_ bv14 4))))
					(not (= (select T_LSQ_ROB_dst (_ bv4 4)) (select T_LSQ_ROB_dst (_ bv15 4))))
					(not (= (select T_LSQ_ROB_dst (_ bv4 4)) (select T_RS_ROB_dst (_ bv0 3))))
					(not (= (select T_LSQ_ROB_dst (_ bv4 4)) (select T_RS_ROB_dst (_ bv1 3))))
					(not (= (select T_LSQ_ROB_dst (_ bv4 4)) (select T_RS_ROB_dst (_ bv2 3))))
					(not (= (select T_LSQ_ROB_dst (_ bv4 4)) (select T_RS_ROB_dst (_ bv3 3))))
					(not (= (select T_LSQ_ROB_dst (_ bv4 4)) (select T_RS_ROB_dst (_ bv4 3))))
					(not (= (select T_LSQ_ROB_dst (_ bv4 4)) (select T_RS_ROB_dst (_ bv5 3))))
					(not (= (select T_LSQ_ROB_dst (_ bv4 4)) (select T_RS_ROB_dst (_ bv6 3))))
					(not (= (select T_LSQ_ROB_dst (_ bv4 4)) (select T_RS_ROB_dst (_ bv7 3)))))) ;done


				;; LSQ Entry 5
				(=> (= #b1 (select T_LSQ_busy (_ bv5 4))) (and 
					(not (= (select T_LSQ_ROB_dst (_ bv5 4)) (select T_LSQ_ROB_dst (_ bv0 4))))
					(not (= (select T_LSQ_ROB_dst (_ bv5 4)) (select T_LSQ_ROB_dst (_ bv1 4))))
					(not (= (select T_LSQ_ROB_dst (_ bv5 4)) (select T_LSQ_ROB_dst (_ bv2 4))))
					(not (= (select T_LSQ_ROB_dst (_ bv5 4)) (select T_LSQ_ROB_dst (_ bv3 4))))
					(not (= (select T_LSQ_ROB_dst (_ bv5 4)) (select T_LSQ_ROB_dst (_ bv4 4))))
					(not (= (select T_LSQ_ROB_dst (_ bv5 4)) (select T_LSQ_ROB_dst (_ bv6 4))))
					(not (= (select T_LSQ_ROB_dst (_ bv5 4)) (select T_LSQ_ROB_dst (_ bv7 4))))
					(not (= (select T_LSQ_ROB_dst (_ bv5 4)) (select T_LSQ_ROB_dst (_ bv8 4))))
					(not (= (select T_LSQ_ROB_dst (_ bv5 4)) (select T_LSQ_ROB_dst (_ bv9 4))))
					(not (= (select T_LSQ_ROB_dst (_ bv5 4)) (select T_LSQ_ROB_dst (_ bv10 4))))
					(not (= (select T_LSQ_ROB_dst (_ bv5 4)) (select T_LSQ_ROB_dst (_ bv11 4))))
					(not (= (select T_LSQ_ROB_dst (_ bv5 4)) (select T_LSQ_ROB_dst (_ bv12 4))))
					(not (= (select T_LSQ_ROB_dst (_ bv5 4)) (select T_LSQ_ROB_dst (_ bv13 4))))
					(not (= (select T_LSQ_ROB_dst (_ bv5 4)) (select T_LSQ_ROB_dst (_ bv14 4))))
					(not (= (select T_LSQ_ROB_dst (_ bv5 4)) (select T_LSQ_ROB_dst (_ bv15 4))))
					(not (= (select T_LSQ_ROB_dst (_ bv5 4)) (select T_RS_ROB_dst (_ bv0 3))))
					(not (= (select T_LSQ_ROB_dst (_ bv5 4)) (select T_RS_ROB_dst (_ bv1 3))))
					(not (= (select T_LSQ_ROB_dst (_ bv5 4)) (select T_RS_ROB_dst (_ bv2 3))))
					(not (= (select T_LSQ_ROB_dst (_ bv5 4)) (select T_RS_ROB_dst (_ bv3 3))))
					(not (= (select T_LSQ_ROB_dst (_ bv5 4)) (select T_RS_ROB_dst (_ bv4 3))))
					(not (= (select T_LSQ_ROB_dst (_ bv5 4)) (select T_RS_ROB_dst (_ bv5 3))))
					(not (= (select T_LSQ_ROB_dst (_ bv5 4)) (select T_RS_ROB_dst (_ bv6 3))))
					(not (= (select T_LSQ_ROB_dst (_ bv5 4)) (select T_RS_ROB_dst (_ bv7 3)))))) ;done


				;; LSQ Entry 6
				(=> (= #b1 (select T_LSQ_busy (_ bv6 4))) (and 
					(not (= (select T_LSQ_ROB_dst (_ bv6 4)) (select T_LSQ_ROB_dst (_ bv0 4))))
					(not (= (select T_LSQ_ROB_dst (_ bv6 4)) (select T_LSQ_ROB_dst (_ bv1 4))))
					(not (= (select T_LSQ_ROB_dst (_ bv6 4)) (select T_LSQ_ROB_dst (_ bv2 4))))
					(not (= (select T_LSQ_ROB_dst (_ bv6 4)) (select T_LSQ_ROB_dst (_ bv3 4))))
					(not (= (select T_LSQ_ROB_dst (_ bv6 4)) (select T_LSQ_ROB_dst (_ bv4 4))))
					(not (= (select T_LSQ_ROB_dst (_ bv6 4)) (select T_LSQ_ROB_dst (_ bv5 4))))
					(not (= (select T_LSQ_ROB_dst (_ bv6 4)) (select T_LSQ_ROB_dst (_ bv7 4))))
					(not (= (select T_LSQ_ROB_dst (_ bv6 4)) (select T_LSQ_ROB_dst (_ bv8 4))))
					(not (= (select T_LSQ_ROB_dst (_ bv6 4)) (select T_LSQ_ROB_dst (_ bv9 4))))
					(not (= (select T_LSQ_ROB_dst (_ bv6 4)) (select T_LSQ_ROB_dst (_ bv10 4))))
					(not (= (select T_LSQ_ROB_dst (_ bv6 4)) (select T_LSQ_ROB_dst (_ bv11 4))))
					(not (= (select T_LSQ_ROB_dst (_ bv6 4)) (select T_LSQ_ROB_dst (_ bv12 4))))
					(not (= (select T_LSQ_ROB_dst (_ bv6 4)) (select T_LSQ_ROB_dst (_ bv13 4))))
					(not (= (select T_LSQ_ROB_dst (_ bv6 4)) (select T_LSQ_ROB_dst (_ bv14 4))))
					(not (= (select T_LSQ_ROB_dst (_ bv6 4)) (select T_LSQ_ROB_dst (_ bv15 4))))
					(not (= (select T_LSQ_ROB_dst (_ bv6 4)) (select T_RS_ROB_dst (_ bv0 3))))
					(not (= (select T_LSQ_ROB_dst (_ bv6 4)) (select T_RS_ROB_dst (_ bv1 3))))
					(not (= (select T_LSQ_ROB_dst (_ bv6 4)) (select T_RS_ROB_dst (_ bv2 3))))
					(not (= (select T_LSQ_ROB_dst (_ bv6 4)) (select T_RS_ROB_dst (_ bv3 3))))
					(not (= (select T_LSQ_ROB_dst (_ bv6 4)) (select T_RS_ROB_dst (_ bv4 3))))
					(not (= (select T_LSQ_ROB_dst (_ bv6 4)) (select T_RS_ROB_dst (_ bv5 3))))
					(not (= (select T_LSQ_ROB_dst (_ bv6 4)) (select T_RS_ROB_dst (_ bv6 3))))
					(not (= (select T_LSQ_ROB_dst (_ bv6 4)) (select T_RS_ROB_dst (_ bv7 3)))))) ;done


				;; LSQ Entry 7
				(=> (= #b1 (select T_LSQ_busy (_ bv7 4))) (and 
					(not (= (select T_LSQ_ROB_dst (_ bv7 4)) (select T_LSQ_ROB_dst (_ bv0 4))))
					(not (= (select T_LSQ_ROB_dst (_ bv7 4)) (select T_LSQ_ROB_dst (_ bv1 4))))
					(not (= (select T_LSQ_ROB_dst (_ bv7 4)) (select T_LSQ_ROB_dst (_ bv2 4))))
					(not (= (select T_LSQ_ROB_dst (_ bv7 4)) (select T_LSQ_ROB_dst (_ bv3 4))))
					(not (= (select T_LSQ_ROB_dst (_ bv7 4)) (select T_LSQ_ROB_dst (_ bv4 4))))
					(not (= (select T_LSQ_ROB_dst (_ bv7 4)) (select T_LSQ_ROB_dst (_ bv5 4))))
					(not (= (select T_LSQ_ROB_dst (_ bv7 4)) (select T_LSQ_ROB_dst (_ bv6 4))))
					(not (= (select T_LSQ_ROB_dst (_ bv7 4)) (select T_LSQ_ROB_dst (_ bv8 4))))
					(not (= (select T_LSQ_ROB_dst (_ bv7 4)) (select T_LSQ_ROB_dst (_ bv9 4))))
					(not (= (select T_LSQ_ROB_dst (_ bv7 4)) (select T_LSQ_ROB_dst (_ bv10 4))))
					(not (= (select T_LSQ_ROB_dst (_ bv7 4)) (select T_LSQ_ROB_dst (_ bv11 4))))
					(not (= (select T_LSQ_ROB_dst (_ bv7 4)) (select T_LSQ_ROB_dst (_ bv12 4))))
					(not (= (select T_LSQ_ROB_dst (_ bv7 4)) (select T_LSQ_ROB_dst (_ bv13 4))))
					(not (= (select T_LSQ_ROB_dst (_ bv7 4)) (select T_LSQ_ROB_dst (_ bv14 4))))
					(not (= (select T_LSQ_ROB_dst (_ bv7 4)) (select T_LSQ_ROB_dst (_ bv15 4))))
					(not (= (select T_LSQ_ROB_dst (_ bv7 4)) (select T_RS_ROB_dst (_ bv0 3))))
					(not (= (select T_LSQ_ROB_dst (_ bv7 4)) (select T_RS_ROB_dst (_ bv1 3))))
					(not (= (select T_LSQ_ROB_dst (_ bv7 4)) (select T_RS_ROB_dst (_ bv2 3))))
					(not (= (select T_LSQ_ROB_dst (_ bv7 4)) (select T_RS_ROB_dst (_ bv3 3))))
					(not (= (select T_LSQ_ROB_dst (_ bv7 4)) (select T_RS_ROB_dst (_ bv4 3))))
					(not (= (select T_LSQ_ROB_dst (_ bv7 4)) (select T_RS_ROB_dst (_ bv5 3))))
					(not (= (select T_LSQ_ROB_dst (_ bv7 4)) (select T_RS_ROB_dst (_ bv6 3))))
					(not (= (select T_LSQ_ROB_dst (_ bv7 4)) (select T_RS_ROB_dst (_ bv7 3)))))) ;done

				;; LSQ Entry 8
				(=> (= #b1 (select T_LSQ_busy (_ bv8 4))) (and 
					(not (= (select T_LSQ_ROB_dst (_ bv8 4)) (select T_LSQ_ROB_dst (_ bv0 4))))
					(not (= (select T_LSQ_ROB_dst (_ bv8 4)) (select T_LSQ_ROB_dst (_ bv1 4))))
					(not (= (select T_LSQ_ROB_dst (_ bv8 4)) (select T_LSQ_ROB_dst (_ bv2 4))))
					(not (= (select T_LSQ_ROB_dst (_ bv8 4)) (select T_LSQ_ROB_dst (_ bv3 4))))
					(not (= (select T_LSQ_ROB_dst (_ bv8 4)) (select T_LSQ_ROB_dst (_ bv4 4))))
					(not (= (select T_LSQ_ROB_dst (_ bv8 4)) (select T_LSQ_ROB_dst (_ bv5 4))))
					(not (= (select T_LSQ_ROB_dst (_ bv8 4)) (select T_LSQ_ROB_dst (_ bv6 4))))
					(not (= (select T_LSQ_ROB_dst (_ bv8 4)) (select T_LSQ_ROB_dst (_ bv7 4))))
					(not (= (select T_LSQ_ROB_dst (_ bv8 4)) (select T_LSQ_ROB_dst (_ bv9 4))))
					(not (= (select T_LSQ_ROB_dst (_ bv8 4)) (select T_LSQ_ROB_dst (_ bv10 4))))
					(not (= (select T_LSQ_ROB_dst (_ bv8 4)) (select T_LSQ_ROB_dst (_ bv11 4))))
					(not (= (select T_LSQ_ROB_dst (_ bv8 4)) (select T_LSQ_ROB_dst (_ bv12 4))))
					(not (= (select T_LSQ_ROB_dst (_ bv8 4)) (select T_LSQ_ROB_dst (_ bv13 4))))
					(not (= (select T_LSQ_ROB_dst (_ bv8 4)) (select T_LSQ_ROB_dst (_ bv14 4))))
					(not (= (select T_LSQ_ROB_dst (_ bv8 4)) (select T_LSQ_ROB_dst (_ bv15 4))))
					(not (= (select T_LSQ_ROB_dst (_ bv8 4)) (select T_RS_ROB_dst (_ bv0 3))))
					(not (= (select T_LSQ_ROB_dst (_ bv8 4)) (select T_RS_ROB_dst (_ bv1 3))))
					(not (= (select T_LSQ_ROB_dst (_ bv8 4)) (select T_RS_ROB_dst (_ bv2 3))))
					(not (= (select T_LSQ_ROB_dst (_ bv8 4)) (select T_RS_ROB_dst (_ bv3 3))))
					(not (= (select T_LSQ_ROB_dst (_ bv8 4)) (select T_RS_ROB_dst (_ bv4 3))))
					(not (= (select T_LSQ_ROB_dst (_ bv8 4)) (select T_RS_ROB_dst (_ bv5 3))))
					(not (= (select T_LSQ_ROB_dst (_ bv8 4)) (select T_RS_ROB_dst (_ bv6 3))))
					(not (= (select T_LSQ_ROB_dst (_ bv8 4)) (select T_RS_ROB_dst (_ bv7 3)))))) ;done


				;; LSQ Entry 9
				(=> (= #b1 (select T_LSQ_busy (_ bv9 4))) (and 
					(not (= (select T_LSQ_ROB_dst (_ bv9 4)) (select T_LSQ_ROB_dst (_ bv0 4))))
					(not (= (select T_LSQ_ROB_dst (_ bv9 4)) (select T_LSQ_ROB_dst (_ bv1 4))))
					(not (= (select T_LSQ_ROB_dst (_ bv9 4)) (select T_LSQ_ROB_dst (_ bv2 4))))
					(not (= (select T_LSQ_ROB_dst (_ bv9 4)) (select T_LSQ_ROB_dst (_ bv3 4))))
					(not (= (select T_LSQ_ROB_dst (_ bv9 4)) (select T_LSQ_ROB_dst (_ bv4 4))))
					(not (= (select T_LSQ_ROB_dst (_ bv9 4)) (select T_LSQ_ROB_dst (_ bv5 4))))
					(not (= (select T_LSQ_ROB_dst (_ bv9 4)) (select T_LSQ_ROB_dst (_ bv6 4))))
					(not (= (select T_LSQ_ROB_dst (_ bv9 4)) (select T_LSQ_ROB_dst (_ bv7 4))))
					(not (= (select T_LSQ_ROB_dst (_ bv9 4)) (select T_LSQ_ROB_dst (_ bv8 4))))
					(not (= (select T_LSQ_ROB_dst (_ bv9 4)) (select T_LSQ_ROB_dst (_ bv10 4))))
					(not (= (select T_LSQ_ROB_dst (_ bv9 4)) (select T_LSQ_ROB_dst (_ bv11 4))))
					(not (= (select T_LSQ_ROB_dst (_ bv9 4)) (select T_LSQ_ROB_dst (_ bv12 4))))
					(not (= (select T_LSQ_ROB_dst (_ bv9 4)) (select T_LSQ_ROB_dst (_ bv13 4))))
					(not (= (select T_LSQ_ROB_dst (_ bv9 4)) (select T_LSQ_ROB_dst (_ bv14 4))))
					(not (= (select T_LSQ_ROB_dst (_ bv9 4)) (select T_LSQ_ROB_dst (_ bv15 4))))
					(not (= (select T_LSQ_ROB_dst (_ bv9 4)) (select T_RS_ROB_dst (_ bv0 3))))
					(not (= (select T_LSQ_ROB_dst (_ bv9 4)) (select T_RS_ROB_dst (_ bv1 3))))
					(not (= (select T_LSQ_ROB_dst (_ bv9 4)) (select T_RS_ROB_dst (_ bv2 3))))
					(not (= (select T_LSQ_ROB_dst (_ bv9 4)) (select T_RS_ROB_dst (_ bv3 3))))
					(not (= (select T_LSQ_ROB_dst (_ bv9 4)) (select T_RS_ROB_dst (_ bv4 3))))
					(not (= (select T_LSQ_ROB_dst (_ bv9 4)) (select T_RS_ROB_dst (_ bv5 3))))
					(not (= (select T_LSQ_ROB_dst (_ bv9 4)) (select T_RS_ROB_dst (_ bv6 3))))
					(not (= (select T_LSQ_ROB_dst (_ bv9 4)) (select T_RS_ROB_dst (_ bv7 3)))))) ;done


				;; LSQ Entry 10
				(=> (= #b1 (select T_LSQ_busy (_ bv10 4))) (and 
					(not (= (select T_LSQ_ROB_dst (_ bv10 4)) (select T_LSQ_ROB_dst (_ bv0 4))))
					(not (= (select T_LSQ_ROB_dst (_ bv10 4)) (select T_LSQ_ROB_dst (_ bv1 4))))
					(not (= (select T_LSQ_ROB_dst (_ bv10 4)) (select T_LSQ_ROB_dst (_ bv2 4))))
					(not (= (select T_LSQ_ROB_dst (_ bv10 4)) (select T_LSQ_ROB_dst (_ bv3 4))))
					(not (= (select T_LSQ_ROB_dst (_ bv10 4)) (select T_LSQ_ROB_dst (_ bv4 4))))
					(not (= (select T_LSQ_ROB_dst (_ bv10 4)) (select T_LSQ_ROB_dst (_ bv5 4))))
					(not (= (select T_LSQ_ROB_dst (_ bv10 4)) (select T_LSQ_ROB_dst (_ bv6 4))))
					(not (= (select T_LSQ_ROB_dst (_ bv10 4)) (select T_LSQ_ROB_dst (_ bv7 4))))
					(not (= (select T_LSQ_ROB_dst (_ bv10 4)) (select T_LSQ_ROB_dst (_ bv8 4))))
					(not (= (select T_LSQ_ROB_dst (_ bv10 4)) (select T_LSQ_ROB_dst (_ bv9 4))))
					(not (= (select T_LSQ_ROB_dst (_ bv10 4)) (select T_LSQ_ROB_dst (_ bv11 4))))
					(not (= (select T_LSQ_ROB_dst (_ bv10 4)) (select T_LSQ_ROB_dst (_ bv12 4))))
					(not (= (select T_LSQ_ROB_dst (_ bv10 4)) (select T_LSQ_ROB_dst (_ bv13 4))))
					(not (= (select T_LSQ_ROB_dst (_ bv10 4)) (select T_LSQ_ROB_dst (_ bv14 4))))
					(not (= (select T_LSQ_ROB_dst (_ bv10 4)) (select T_LSQ_ROB_dst (_ bv15 4))))
					(not (= (select T_LSQ_ROB_dst (_ bv10 4)) (select T_RS_ROB_dst (_ bv0 3))))
					(not (= (select T_LSQ_ROB_dst (_ bv10 4)) (select T_RS_ROB_dst (_ bv1 3))))
					(not (= (select T_LSQ_ROB_dst (_ bv10 4)) (select T_RS_ROB_dst (_ bv2 3))))
					(not (= (select T_LSQ_ROB_dst (_ bv10 4)) (select T_RS_ROB_dst (_ bv3 3))))
					(not (= (select T_LSQ_ROB_dst (_ bv10 4)) (select T_RS_ROB_dst (_ bv4 3))))
					(not (= (select T_LSQ_ROB_dst (_ bv10 4)) (select T_RS_ROB_dst (_ bv5 3))))
					(not (= (select T_LSQ_ROB_dst (_ bv10 4)) (select T_RS_ROB_dst (_ bv6 3))))
					(not (= (select T_LSQ_ROB_dst (_ bv10 4)) (select T_RS_ROB_dst (_ bv7 3)))))) ;done

					;; LSQ Entry 11
				(=> (= #b1 (select T_LSQ_busy (_ bv11 4))) (and 
					(not (= (select T_LSQ_ROB_dst (_ bv11 4)) (select T_LSQ_ROB_dst (_ bv0 4))))
					(not (= (select T_LSQ_ROB_dst (_ bv11 4)) (select T_LSQ_ROB_dst (_ bv1 4))))
					(not (= (select T_LSQ_ROB_dst (_ bv11 4)) (select T_LSQ_ROB_dst (_ bv2 4))))
					(not (= (select T_LSQ_ROB_dst (_ bv11 4)) (select T_LSQ_ROB_dst (_ bv3 4))))
					(not (= (select T_LSQ_ROB_dst (_ bv11 4)) (select T_LSQ_ROB_dst (_ bv4 4))))
					(not (= (select T_LSQ_ROB_dst (_ bv11 4)) (select T_LSQ_ROB_dst (_ bv5 4))))
					(not (= (select T_LSQ_ROB_dst (_ bv11 4)) (select T_LSQ_ROB_dst (_ bv6 4))))
					(not (= (select T_LSQ_ROB_dst (_ bv11 4)) (select T_LSQ_ROB_dst (_ bv7 4))))
					(not (= (select T_LSQ_ROB_dst (_ bv11 4)) (select T_LSQ_ROB_dst (_ bv8 4))))
					(not (= (select T_LSQ_ROB_dst (_ bv11 4)) (select T_LSQ_ROB_dst (_ bv9 4))))
					(not (= (select T_LSQ_ROB_dst (_ bv11 4)) (select T_LSQ_ROB_dst (_ bv10 4))))
					(not (= (select T_LSQ_ROB_dst (_ bv11 4)) (select T_LSQ_ROB_dst (_ bv12 4))))
					(not (= (select T_LSQ_ROB_dst (_ bv11 4)) (select T_LSQ_ROB_dst (_ bv13 4))))
					(not (= (select T_LSQ_ROB_dst (_ bv11 4)) (select T_LSQ_ROB_dst (_ bv14 4))))
					(not (= (select T_LSQ_ROB_dst (_ bv11 4)) (select T_LSQ_ROB_dst (_ bv15 4))))
					(not (= (select T_LSQ_ROB_dst (_ bv11 4)) (select T_RS_ROB_dst (_ bv0 3))))
					(not (= (select T_LSQ_ROB_dst (_ bv11 4)) (select T_RS_ROB_dst (_ bv1 3))))
					(not (= (select T_LSQ_ROB_dst (_ bv11 4)) (select T_RS_ROB_dst (_ bv2 3))))
					(not (= (select T_LSQ_ROB_dst (_ bv11 4)) (select T_RS_ROB_dst (_ bv3 3))))
					(not (= (select T_LSQ_ROB_dst (_ bv11 4)) (select T_RS_ROB_dst (_ bv4 3))))
					(not (= (select T_LSQ_ROB_dst (_ bv11 4)) (select T_RS_ROB_dst (_ bv5 3))))
					(not (= (select T_LSQ_ROB_dst (_ bv11 4)) (select T_RS_ROB_dst (_ bv6 3))))
					(not (= (select T_LSQ_ROB_dst (_ bv11 4)) (select T_RS_ROB_dst (_ bv7 3)))))) ;done

					;; LSQ Entry 12
				(=> (= #b1 (select T_LSQ_busy (_ bv12 4))) (and 
					(not (= (select T_LSQ_ROB_dst (_ bv12 4)) (select T_LSQ_ROB_dst (_ bv0 4))))
					(not (= (select T_LSQ_ROB_dst (_ bv12 4)) (select T_LSQ_ROB_dst (_ bv1 4))))
					(not (= (select T_LSQ_ROB_dst (_ bv12 4)) (select T_LSQ_ROB_dst (_ bv2 4))))
					(not (= (select T_LSQ_ROB_dst (_ bv12 4)) (select T_LSQ_ROB_dst (_ bv3 4))))
					(not (= (select T_LSQ_ROB_dst (_ bv12 4)) (select T_LSQ_ROB_dst (_ bv4 4))))
					(not (= (select T_LSQ_ROB_dst (_ bv12 4)) (select T_LSQ_ROB_dst (_ bv5 4))))
					(not (= (select T_LSQ_ROB_dst (_ bv12 4)) (select T_LSQ_ROB_dst (_ bv6 4))))
					(not (= (select T_LSQ_ROB_dst (_ bv12 4)) (select T_LSQ_ROB_dst (_ bv7 4))))
					(not (= (select T_LSQ_ROB_dst (_ bv12 4)) (select T_LSQ_ROB_dst (_ bv8 4))))
					(not (= (select T_LSQ_ROB_dst (_ bv12 4)) (select T_LSQ_ROB_dst (_ bv9 4))))
					(not (= (select T_LSQ_ROB_dst (_ bv12 4)) (select T_LSQ_ROB_dst (_ bv10 4))))
					(not (= (select T_LSQ_ROB_dst (_ bv12 4)) (select T_LSQ_ROB_dst (_ bv11 4))))
					(not (= (select T_LSQ_ROB_dst (_ bv12 4)) (select T_LSQ_ROB_dst (_ bv13 4))))
					(not (= (select T_LSQ_ROB_dst (_ bv12 4)) (select T_LSQ_ROB_dst (_ bv14 4))))
					(not (= (select T_LSQ_ROB_dst (_ bv12 4)) (select T_LSQ_ROB_dst (_ bv15 4))))
					(not (= (select T_LSQ_ROB_dst (_ bv12 4)) (select T_RS_ROB_dst (_ bv0 3))))
					(not (= (select T_LSQ_ROB_dst (_ bv12 4)) (select T_RS_ROB_dst (_ bv1 3))))
					(not (= (select T_LSQ_ROB_dst (_ bv12 4)) (select T_RS_ROB_dst (_ bv2 3))))
					(not (= (select T_LSQ_ROB_dst (_ bv12 4)) (select T_RS_ROB_dst (_ bv3 3))))
					(not (= (select T_LSQ_ROB_dst (_ bv12 4)) (select T_RS_ROB_dst (_ bv4 3))))
					(not (= (select T_LSQ_ROB_dst (_ bv12 4)) (select T_RS_ROB_dst (_ bv5 3))))
					(not (= (select T_LSQ_ROB_dst (_ bv12 4)) (select T_RS_ROB_dst (_ bv6 3))))
					(not (= (select T_LSQ_ROB_dst (_ bv12 4)) (select T_RS_ROB_dst (_ bv7 3)))))) ;done
					;; LSQ Entry 13
				(=> (= #b1 (select T_LSQ_busy (_ bv13 4))) (and 
					(not (= (select T_LSQ_ROB_dst (_ bv13 4)) (select T_LSQ_ROB_dst (_ bv0 4))))
					(not (= (select T_LSQ_ROB_dst (_ bv13 4)) (select T_LSQ_ROB_dst (_ bv1 4))))
					(not (= (select T_LSQ_ROB_dst (_ bv13 4)) (select T_LSQ_ROB_dst (_ bv2 4))))
					(not (= (select T_LSQ_ROB_dst (_ bv13 4)) (select T_LSQ_ROB_dst (_ bv3 4))))
					(not (= (select T_LSQ_ROB_dst (_ bv13 4)) (select T_LSQ_ROB_dst (_ bv4 4))))
					(not (= (select T_LSQ_ROB_dst (_ bv13 4)) (select T_LSQ_ROB_dst (_ bv5 4))))
					(not (= (select T_LSQ_ROB_dst (_ bv13 4)) (select T_LSQ_ROB_dst (_ bv6 4))))
					(not (= (select T_LSQ_ROB_dst (_ bv13 4)) (select T_LSQ_ROB_dst (_ bv7 4))))
					(not (= (select T_LSQ_ROB_dst (_ bv13 4)) (select T_LSQ_ROB_dst (_ bv8 4))))
					(not (= (select T_LSQ_ROB_dst (_ bv13 4)) (select T_LSQ_ROB_dst (_ bv9 4))))
					(not (= (select T_LSQ_ROB_dst (_ bv13 4)) (select T_LSQ_ROB_dst (_ bv10 4))))
					(not (= (select T_LSQ_ROB_dst (_ bv13 4)) (select T_LSQ_ROB_dst (_ bv11 4))))
					(not (= (select T_LSQ_ROB_dst (_ bv13 4)) (select T_LSQ_ROB_dst (_ bv12 4))))
					(not (= (select T_LSQ_ROB_dst (_ bv13 4)) (select T_LSQ_ROB_dst (_ bv14 4))))
					(not (= (select T_LSQ_ROB_dst (_ bv13 4)) (select T_LSQ_ROB_dst (_ bv15 4))))
					(not (= (select T_LSQ_ROB_dst (_ bv13 4)) (select T_RS_ROB_dst (_ bv0 3))))
					(not (= (select T_LSQ_ROB_dst (_ bv13 4)) (select T_RS_ROB_dst (_ bv1 3))))
					(not (= (select T_LSQ_ROB_dst (_ bv13 4)) (select T_RS_ROB_dst (_ bv2 3))))
					(not (= (select T_LSQ_ROB_dst (_ bv13 4)) (select T_RS_ROB_dst (_ bv3 3))))
					(not (= (select T_LSQ_ROB_dst (_ bv13 4)) (select T_RS_ROB_dst (_ bv4 3))))
					(not (= (select T_LSQ_ROB_dst (_ bv13 4)) (select T_RS_ROB_dst (_ bv5 3))))
					(not (= (select T_LSQ_ROB_dst (_ bv13 4)) (select T_RS_ROB_dst (_ bv6 3))))
					(not (= (select T_LSQ_ROB_dst (_ bv13 4)) (select T_RS_ROB_dst (_ bv7 3)))))) ;done

					;; LSQ Entry 14
				(=> (= #b1 (select T_LSQ_busy (_ bv14 4))) (and 
					(not (= (select T_LSQ_ROB_dst (_ bv14 4)) (select T_LSQ_ROB_dst (_ bv0 4))))
					(not (= (select T_LSQ_ROB_dst (_ bv14 4)) (select T_LSQ_ROB_dst (_ bv1 4))))
					(not (= (select T_LSQ_ROB_dst (_ bv14 4)) (select T_LSQ_ROB_dst (_ bv2 4))))
					(not (= (select T_LSQ_ROB_dst (_ bv14 4)) (select T_LSQ_ROB_dst (_ bv3 4))))
					(not (= (select T_LSQ_ROB_dst (_ bv14 4)) (select T_LSQ_ROB_dst (_ bv4 4))))
					(not (= (select T_LSQ_ROB_dst (_ bv14 4)) (select T_LSQ_ROB_dst (_ bv5 4))))
					(not (= (select T_LSQ_ROB_dst (_ bv14 4)) (select T_LSQ_ROB_dst (_ bv6 4))))
					(not (= (select T_LSQ_ROB_dst (_ bv14 4)) (select T_LSQ_ROB_dst (_ bv7 4))))
					(not (= (select T_LSQ_ROB_dst (_ bv14 4)) (select T_LSQ_ROB_dst (_ bv8 4))))
					(not (= (select T_LSQ_ROB_dst (_ bv14 4)) (select T_LSQ_ROB_dst (_ bv9 4))))
					(not (= (select T_LSQ_ROB_dst (_ bv14 4)) (select T_LSQ_ROB_dst (_ bv10 4))))
					(not (= (select T_LSQ_ROB_dst (_ bv14 4)) (select T_LSQ_ROB_dst (_ bv11 4))))
					(not (= (select T_LSQ_ROB_dst (_ bv14 4)) (select T_LSQ_ROB_dst (_ bv12 4))))
					(not (= (select T_LSQ_ROB_dst (_ bv14 4)) (select T_LSQ_ROB_dst (_ bv13 4))))
					(not (= (select T_LSQ_ROB_dst (_ bv14 4)) (select T_LSQ_ROB_dst (_ bv15 4))))
					(not (= (select T_LSQ_ROB_dst (_ bv14 4)) (select T_RS_ROB_dst (_ bv0 3))))
					(not (= (select T_LSQ_ROB_dst (_ bv14 4)) (select T_RS_ROB_dst (_ bv1 3))))
					(not (= (select T_LSQ_ROB_dst (_ bv14 4)) (select T_RS_ROB_dst (_ bv2 3))))
					(not (= (select T_LSQ_ROB_dst (_ bv14 4)) (select T_RS_ROB_dst (_ bv3 3))))
					(not (= (select T_LSQ_ROB_dst (_ bv14 4)) (select T_RS_ROB_dst (_ bv4 3))))
					(not (= (select T_LSQ_ROB_dst (_ bv14 4)) (select T_RS_ROB_dst (_ bv5 3))))
					(not (= (select T_LSQ_ROB_dst (_ bv14 4)) (select T_RS_ROB_dst (_ bv6 3))))
					(not (= (select T_LSQ_ROB_dst (_ bv14 4)) (select T_RS_ROB_dst (_ bv7 3)))))) ;done


					;; LSQ Entry 15
				(=> (= #b1 (select T_LSQ_busy (_ bv15 4))) (and 
					(not (= (select T_LSQ_ROB_dst (_ bv15 4)) (select T_LSQ_ROB_dst (_ bv0 4))))
					(not (= (select T_LSQ_ROB_dst (_ bv15 4)) (select T_LSQ_ROB_dst (_ bv1 4))))
					(not (= (select T_LSQ_ROB_dst (_ bv15 4)) (select T_LSQ_ROB_dst (_ bv2 4))))
					(not (= (select T_LSQ_ROB_dst (_ bv15 4)) (select T_LSQ_ROB_dst (_ bv3 4))))
					(not (= (select T_LSQ_ROB_dst (_ bv15 4)) (select T_LSQ_ROB_dst (_ bv4 4))))
					(not (= (select T_LSQ_ROB_dst (_ bv15 4)) (select T_LSQ_ROB_dst (_ bv5 4))))
					(not (= (select T_LSQ_ROB_dst (_ bv15 4)) (select T_LSQ_ROB_dst (_ bv6 4))))
					(not (= (select T_LSQ_ROB_dst (_ bv15 4)) (select T_LSQ_ROB_dst (_ bv7 4))))
					(not (= (select T_LSQ_ROB_dst (_ bv15 4)) (select T_LSQ_ROB_dst (_ bv8 4))))
					(not (= (select T_LSQ_ROB_dst (_ bv15 4)) (select T_LSQ_ROB_dst (_ bv9 4))))
					(not (= (select T_LSQ_ROB_dst (_ bv15 4)) (select T_LSQ_ROB_dst (_ bv10 4))))
					(not (= (select T_LSQ_ROB_dst (_ bv15 4)) (select T_LSQ_ROB_dst (_ bv11 4))))
					(not (= (select T_LSQ_ROB_dst (_ bv15 4)) (select T_LSQ_ROB_dst (_ bv12 4))))
					(not (= (select T_LSQ_ROB_dst (_ bv15 4)) (select T_LSQ_ROB_dst (_ bv13 4))))
					(not (= (select T_LSQ_ROB_dst (_ bv15 4)) (select T_LSQ_ROB_dst (_ bv14 4))))
					(not (= (select T_LSQ_ROB_dst (_ bv15 4)) (select T_RS_ROB_dst (_ bv0 3))))
					(not (= (select T_LSQ_ROB_dst (_ bv15 4)) (select T_RS_ROB_dst (_ bv1 3))))
					(not (= (select T_LSQ_ROB_dst (_ bv15 4)) (select T_RS_ROB_dst (_ bv2 3))))
					(not (= (select T_LSQ_ROB_dst (_ bv15 4)) (select T_RS_ROB_dst (_ bv3 3))))
					(not (= (select T_LSQ_ROB_dst (_ bv15 4)) (select T_RS_ROB_dst (_ bv4 3))))
					(not (= (select T_LSQ_ROB_dst (_ bv15 4)) (select T_RS_ROB_dst (_ bv5 3))))
					(not (= (select T_LSQ_ROB_dst (_ bv15 4)) (select T_RS_ROB_dst (_ bv6 3))))
					(not (= (select T_LSQ_ROB_dst (_ bv15 4)) (select T_RS_ROB_dst (_ bv7 3)))))) ;done

;)	


;-----------------------------Main Invariant 1---------------------------------------------------------------
				(=> (= #b1 (select T_Cache_Valid (_ bv0 2))) (and (= #b1 T_SC_pass0) (= #b1 T_TC_pass0)))
				(=> (= #b1 (select T_Cache_Valid (_ bv1 2))) (and (= #b1 T_SC_pass1) (= #b1 T_TC_pass1)))
				(=> (= #b1 (select T_Cache_Valid (_ bv2 2))) (and (= #b1 T_SC_pass2) (= #b1 T_TC_pass2)))
				(=> (= #b1 (select T_Cache_Valid (_ bv3 2))) (and (= #b1 T_SC_pass3) (= #b1 T_TC_pass3)))

;(----------------------------General Declarations-------------------------------------------------
				(= 0 (select empty_ROB_int (_ bv0 6)))
				(= 0 (select empty_ROB_int (_ bv1 6)))
				(= 0 (select empty_ROB_int (_ bv2 6)))
				(= 0 (select empty_ROB_int (_ bv3 6)))
				(= 0 (select empty_ROB_int (_ bv4 6)))
				(= 0 (select empty_ROB_int (_ bv5 6)))
				(= 0 (select empty_ROB_int (_ bv6 6)))
				(= 0 (select empty_ROB_int (_ bv7 6)))	
				(= 0 (select empty_ROB_int (_ bv8 6)))
				(= 0 (select empty_ROB_int (_ bv9 6)))
				(= 0 (select empty_ROB_int (_ bv10 6)))
				(= 0 (select empty_ROB_int (_ bv11 6)))
				(= 0 (select empty_ROB_int (_ bv12 6)))
				(= 0 (select empty_ROB_int (_ bv13 6)))
				(= 0 (select empty_ROB_int (_ bv14 6)))
				(= 0 (select empty_ROB_int (_ bv15 6)))
				(= 0 (select empty_ROB_int (_ bv16 6)))
				(= 0 (select empty_ROB_int (_ bv17 6)))
				(= 0 (select empty_ROB_int (_ bv18 6)))
				(= 0 (select empty_ROB_int (_ bv19 6)))
				(= 0 (select empty_ROB_int (_ bv20 6)))
				(= 0 (select empty_ROB_int (_ bv21 6)))
				(= 0 (select empty_ROB_int (_ bv22 6)))
				(= 0 (select empty_ROB_int (_ bv23 6)))
				(= 0 (select empty_ROB_int (_ bv24 6)))
				(= 0 (select empty_ROB_int (_ bv25 6)))
				(= 0 (select empty_ROB_int (_ bv26 6)))
				(= 0 (select empty_ROB_int (_ bv27 6)))
				(= 0 (select empty_ROB_int (_ bv28 6)))
				(= 0 (select empty_ROB_int (_ bv29 6)))
				(= 0 (select empty_ROB_int (_ bv30 6)))
				(= 0 (select empty_ROB_int (_ bv31 6)))
				(= 0 (select empty_ROB_int (_ bv32 6)))
				(= 0 (select empty_ROB_int (_ bv33 6)))
				(= 0 (select empty_ROB_int (_ bv34 6)))
				(= 0 (select empty_ROB_int (_ bv35 6)))
				(= 0 (select empty_ROB_int (_ bv36 6)))
				(= 0 (select empty_ROB_int (_ bv37 6)))
				(= 0 (select empty_ROB_int (_ bv38 6)))
				(= 0 (select empty_ROB_int (_ bv39 6)))
				(= 0 (select empty_ROB_int (_ bv40 6)))
				(= 0 (select empty_ROB_int (_ bv41 6)))
				(= 0 (select empty_ROB_int (_ bv42 6)))
				(= 0 (select empty_ROB_int (_ bv43 6)))
				(= 0 (select empty_ROB_int (_ bv44 6)))
				(= 0 (select empty_ROB_int (_ bv45 6)))
				(= 0 (select empty_ROB_int (_ bv46 6)))
				(= 0 (select empty_ROB_int (_ bv47 6)))
				(= 0 (select empty_ROB_int (_ bv48 6)))
				(= 0 (select empty_ROB_int (_ bv49 6)))
				(= 0 (select empty_ROB_int (_ bv50 6)))
				(= 0 (select empty_ROB_int (_ bv51 6)))
				(= 0 (select empty_ROB_int (_ bv52 6)))
				(= 0 (select empty_ROB_int (_ bv53 6)))
				(= 0 (select empty_ROB_int (_ bv54 6)))
				(= 0 (select empty_ROB_int (_ bv55 6)))
				(= 0 (select empty_ROB_int (_ bv56 6)))
				(= 0 (select empty_ROB_int (_ bv57 6)))
				(= 0 (select empty_ROB_int (_ bv58 6)))
				(= 0 (select empty_ROB_int (_ bv59 6)))
				(= 0 (select empty_ROB_int (_ bv60 6)))
				(= 0 (select empty_ROB_int (_ bv61 6)))
				(= 0 (select empty_ROB_int (_ bv62 6)))
				(= 0 (select empty_ROB_int (_ bv63 6)))


				(= #b0 (select empty_ROB_1bit (_ bv0 6)))
				(= #b0 (select empty_ROB_1bit (_ bv1 6)))
				(= #b0 (select empty_ROB_1bit (_ bv2 6)))
				(= #b0 (select empty_ROB_1bit (_ bv3 6)))
				(= #b0 (select empty_ROB_1bit (_ bv4 6)))
				(= #b0 (select empty_ROB_1bit (_ bv5 6)))
				(= #b0 (select empty_ROB_1bit (_ bv6 6)))
				(= #b0 (select empty_ROB_1bit (_ bv7 6)))
                (= #b0 (select empty_ROB_1bit (_ bv8 6)))
				(= #b0 (select empty_ROB_1bit (_ bv9 6)))
				(= #b0 (select empty_ROB_1bit (_ bv10 6)))
				(= #b0 (select empty_ROB_1bit (_ bv11 6)))
				(= #b0 (select empty_ROB_1bit (_ bv12 6)))
				(= #b0 (select empty_ROB_1bit (_ bv13 6)))
				(= #b0 (select empty_ROB_1bit (_ bv14 6)))
				(= #b0 (select empty_ROB_1bit (_ bv15 6)))
				(= #b0 (select empty_ROB_1bit (_ bv16 6)))
				(= #b0 (select empty_ROB_1bit (_ bv17 6)))
				(= #b0 (select empty_ROB_1bit (_ bv18 6)))
				(= #b0 (select empty_ROB_1bit (_ bv19 6)))
				(= #b0 (select empty_ROB_1bit (_ bv20 6)))
				(= #b0 (select empty_ROB_1bit (_ bv21 6)))
				(= #b0 (select empty_ROB_1bit (_ bv22 6)))
				(= #b0 (select empty_ROB_1bit (_ bv23 6)))
				(= #b0 (select empty_ROB_1bit (_ bv24 6)))
				(= #b0 (select empty_ROB_1bit (_ bv25 6)))
				(= #b0 (select empty_ROB_1bit (_ bv26 6)))
				(= #b0 (select empty_ROB_1bit (_ bv27 6)))
				(= #b0 (select empty_ROB_1bit (_ bv28 6)))
				(= #b0 (select empty_ROB_1bit (_ bv29 6)))
				(= #b0 (select empty_ROB_1bit (_ bv30 6)))
				(= #b0 (select empty_ROB_1bit (_ bv31 6)))
				(= #b0 (select empty_ROB_1bit (_ bv32 6)))
				(= #b0 (select empty_ROB_1bit (_ bv33 6)))
				(= #b0 (select empty_ROB_1bit (_ bv34 6)))
				(= #b0 (select empty_ROB_1bit (_ bv35 6)))
				(= #b0 (select empty_ROB_1bit (_ bv36 6)))
				(= #b0 (select empty_ROB_1bit (_ bv37 6)))
				(= #b0 (select empty_ROB_1bit (_ bv38 6)))
				(= #b0 (select empty_ROB_1bit (_ bv39 6)))
				(= #b0 (select empty_ROB_1bit (_ bv40 6)))
				(= #b0 (select empty_ROB_1bit (_ bv41 6)))
				(= #b0 (select empty_ROB_1bit (_ bv42 6)))
				(= #b0 (select empty_ROB_1bit (_ bv43 6)))
				(= #b0 (select empty_ROB_1bit (_ bv44 6)))
				(= #b0 (select empty_ROB_1bit (_ bv45 6)))
				(= #b0 (select empty_ROB_1bit (_ bv46 6)))
				(= #b0 (select empty_ROB_1bit (_ bv47 6)))
				(= #b0 (select empty_ROB_1bit (_ bv48 6)))
				(= #b0 (select empty_ROB_1bit (_ bv49 6)))
				(= #b0 (select empty_ROB_1bit (_ bv50 6)))
				(= #b0 (select empty_ROB_1bit (_ bv51 6)))
				(= #b0 (select empty_ROB_1bit (_ bv52 6)))
				(= #b0 (select empty_ROB_1bit (_ bv53 6)))
				(= #b0 (select empty_ROB_1bit (_ bv54 6)))
				(= #b0 (select empty_ROB_1bit (_ bv55 6)))
				(= #b0 (select empty_ROB_1bit (_ bv56 6)))
				(= #b0 (select empty_ROB_1bit (_ bv57 6)))
				(= #b0 (select empty_ROB_1bit (_ bv58 6)))
				(= #b0 (select empty_ROB_1bit (_ bv59 6)))
				(= #b0 (select empty_ROB_1bit (_ bv60 6)))
				(= #b0 (select empty_ROB_1bit (_ bv61 6)))
				(= #b0 (select empty_ROB_1bit (_ bv62 6)))
				(= #b0 (select empty_ROB_1bit (_ bv63 6)))

				
		
				(= #b0 (select empty_RS_1bit (_ bv0 3)))
				(= #b0 (select empty_RS_1bit (_ bv1 3)))
				(= #b0 (select empty_RS_1bit (_ bv2 3)))
				(= #b0 (select empty_RS_1bit (_ bv3 3)))
				(= #b0 (select empty_RS_1bit (_ bv4 3)))
				(= #b0 (select empty_RS_1bit (_ bv5 3)))
				(= #b0 (select empty_RS_1bit (_ bv6 3)))
				(= #b0 (select empty_RS_1bit (_ bv7 3)))

				
				(= #b0 (select empty_LSQ_1bit (_ bv0 4)))
				(= #b0 (select empty_LSQ_1bit (_ bv1 4)))
				(= #b0 (select empty_LSQ_1bit (_ bv2 4)))
				(= #b0 (select empty_LSQ_1bit (_ bv3 4)))
				(= #b0 (select empty_LSQ_1bit (_ bv4 4)))
				(= #b0 (select empty_LSQ_1bit (_ bv5 4)))
				(= #b0 (select empty_LSQ_1bit (_ bv6 4)))
				(= #b0 (select empty_LSQ_1bit (_ bv7 4)))
				(= #b0 (select empty_LSQ_1bit (_ bv8 4)))
				(= #b0 (select empty_LSQ_1bit (_ bv9 4)))
				(= #b0 (select empty_LSQ_1bit (_ bv10 4)))
				(= #b0 (select empty_LSQ_1bit (_ bv11 4)))
				(= #b0 (select empty_LSQ_1bit (_ bv12 4)))
				(= #b0 (select empty_LSQ_1bit (_ bv13 4)))
				(= #b0 (select empty_LSQ_1bit (_ bv14 4)))
				(= #b0 (select empty_LSQ_1bit (_ bv15 4)))




				(= #b000000 (select empty_RS_3bit (_ bv0 3)))
				(= #b000000 (select empty_RS_3bit (_ bv1 3)))
				(= #b000000 (select empty_RS_3bit (_ bv2 3)))
				(= #b000000 (select empty_RS_3bit (_ bv3 3)))
				(= #b000000 (select empty_RS_3bit (_ bv4 3)))
				(= #b000000 (select empty_RS_3bit (_ bv5 3)))
				(= #b000000 (select empty_RS_3bit (_ bv6 3)))
				(= #b000000 (select empty_RS_3bit (_ bv7 3)))


				(= #b000000 (select empty_LSQ_3bit (_ bv0 4)))
				(= #b000000 (select empty_LSQ_3bit (_ bv1 4)))
				(= #b000000 (select empty_LSQ_3bit (_ bv2 4)))
				(= #b000000 (select empty_LSQ_3bit (_ bv3 4)))
				(= #b000000 (select empty_LSQ_3bit (_ bv4 4)))
				(= #b000000 (select empty_LSQ_3bit (_ bv5 4)))
				(= #b000000 (select empty_LSQ_3bit (_ bv6 4)))
				(= #b000000 (select empty_LSQ_3bit (_ bv7 4)))	
				(= #b000000 (select empty_LSQ_3bit (_ bv8 4)))
				(= #b000000 (select empty_LSQ_3bit (_ bv9 4)))
				(= #b000000 (select empty_LSQ_3bit (_ bv10 4)))
				(= #b000000 (select empty_LSQ_3bit (_ bv11 4)))
				(= #b000000 (select empty_LSQ_3bit (_ bv12 4)))
				(= #b000000 (select empty_LSQ_3bit (_ bv13 4)))
				(= #b000000 (select empty_LSQ_3bit (_ bv14 4)))
				(= #b000000 (select empty_LSQ_3bit (_ bv15 4)))		

				(= 0 (select empty_RS_int (_ bv0 3)))
				(= 0 (select empty_RS_int (_ bv1 3)))
				(= 0 (select empty_RS_int (_ bv2 3)))
				(= 0 (select empty_RS_int (_ bv3 3)))
				(= 0 (select empty_RS_int (_ bv4 3)))
				(= 0 (select empty_RS_int (_ bv5 3)))
				(= 0 (select empty_RS_int (_ bv6 3)))
				(= 0 (select empty_RS_int (_ bv7 3)))

				(= 0 (select empty_LSQ_int (_ bv0 4)))
				(= 0 (select empty_LSQ_int (_ bv1 4)))
				(= 0 (select empty_LSQ_int (_ bv2 4)))
				(= 0 (select empty_LSQ_int (_ bv3 4)))
				(= 0 (select empty_LSQ_int (_ bv4 4)))
				(= 0 (select empty_LSQ_int (_ bv5 4)))
				(= 0 (select empty_LSQ_int (_ bv6 4)))
				(= 0 (select empty_LSQ_int (_ bv7 4)))
				(= 0 (select empty_LSQ_int (_ bv8 4)))
				(= 0 (select empty_LSQ_int (_ bv9 4)))
				(= 0 (select empty_LSQ_int (_ bv10 4)))
				(= 0 (select empty_LSQ_int (_ bv11 4)))
				(= 0 (select empty_LSQ_int (_ bv12 4)))
				(= 0 (select empty_LSQ_int (_ bv13 4)))
				(= 0 (select empty_LSQ_int (_ bv14 4)))
				(= 0 (select empty_LSQ_int (_ bv15 4)))
				
				(= SLoad 1)
				(= SStore 2)
				(= Jump 3)
				(= Rtype 4)
				(= Branch 5)
;)


;(-----------------------------Visuals----------------------------------------------------
				(= T_vis_cache_tag0 (select T_Cache_Tag (_ bv0 2)))
				(= T_vis_cache_tag1 (select T_Cache_Tag (_ bv1 2)))
				(= T_vis_cache_tag2 (select T_Cache_Tag (_ bv2 2)))
				(= T_vis_cache_tag3 (select T_Cache_Tag (_ bv3 2)))
				
				(= T_vis_cache_valid0 (select T_Cache_Valid (_ bv0 2)))
				(= T_vis_cache_valid1 (select T_Cache_Valid (_ bv1 2)))
				(= T_vis_cache_valid2 (select T_Cache_Valid (_ bv2 2)))
				(= T_vis_cache_valid3 (select T_Cache_Valid (_ bv3 2)))
				
				(= U4_vis_cache_tag0 (select U4_CacheL1_Tag (_ bv0 2)))
				(= U4_vis_cache_tag1 (select U4_CacheL1_Tag (_ bv1 2)))
				(= U4_vis_cache_tag2 (select U4_CacheL1_Tag (_ bv2 2)))
				(= U4_vis_cache_tag3 (select U4_CacheL1_Tag (_ bv3 2)))
				
				(= U4_vis_cache_valid0 (select U4_CacheL1_Valid (_ bv0 2)))
				(= U4_vis_cache_valid1 (select U4_CacheL1_Valid (_ bv1 2)))
				(= U4_vis_cache_valid2 (select U4_CacheL1_Valid (_ bv2 2)))
				(= U4_vis_cache_valid3 (select U4_CacheL1_Valid (_ bv3 2)))



;)

			)





;-----------------------------Implies This---------------------------------------------------------			
			(and
				(=> (= #b1 (select U4_CacheL1_Valid (_ bv0 2))) (and (= #b1 U4_SC_pass0) (= #b1 U4_TC_pass0)))
				(=> (= #b1 (select U4_CacheL1_Valid (_ bv1 2))) (and (= #b1 U4_SC_pass1) (= #b1 U4_TC_pass1)))
				(=> (= #b1 (select U4_CacheL1_Valid (_ bv2 2))) (and (= #b1 U4_SC_pass2) (= #b1 U4_TC_pass2)))
				(=> (= #b1 (select U4_CacheL1_Valid (_ bv3 2))) (and (= #b1 U4_SC_pass3) (= #b1 U4_TC_pass3)))
			)
			
		)))))))))))))))))))))))))))))))))))))))))))
		)))))))))))))))))))))))))))))))))))))))))))
		)))))))))))))))))))))))))))))))))))))))))))
		)))))))))))))))))))))))))))))))))))))))))))
		)))))))))))))))))))))))))))))))))))))))))))
		)))))))))))))))))))))))))))))))))))))))))))
		))))))))))))))))))))))))))))))))
	)
)
(check-sat)

(get-value (T_vis_cache_tag0))
(get-value (T_vis_cache_tag1))
(get-value (T_vis_cache_tag2))
(get-value (T_vis_cache_tag3))

(get-value (T_vis_cache_valid0))
(get-value (T_vis_cache_valid1))
(get-value (T_vis_cache_valid2))
(get-value (T_vis_cache_valid3))

(get-value (U4_vis_cache_tag0))
(get-value (U4_vis_cache_tag1))
(get-value (U4_vis_cache_tag2))
(get-value (U4_vis_cache_tag3))

(get-value (U4_vis_cache_valid0))
(get-value (U4_vis_cache_valid1))
(get-value (U4_vis_cache_valid2))
(get-value (U4_vis_cache_valid3))