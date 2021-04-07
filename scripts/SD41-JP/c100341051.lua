--鎧皇竜－サイバー・ダーク・エンド・ドラゴン

--Scripted by mallu11
function c100341051.initial_effect(c)
	--fusion material
	c:EnableReviveLimit()
	aux.AddFusionProcCode2(c,40418351,1546123,true,true)
	--spsummon condition
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetValue(aux.fuslimit)
	c:RegisterEffect(e1)
	--spsummon
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e2:SetCode(EFFECT_SPSUMMON_PROC)
	e2:SetRange(LOCATION_EXTRA)
	e2:SetCondition(c100341051.hspcon)
	e2:SetOperation(c100341051.hspop)
	c:RegisterEffect(e2)
	--immune
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_IMMUNE_EFFECT)
	e3:SetRange(LOCATION_MZONE)
	e3:SetValue(c100341051.efilter)
	c:RegisterEffect(e3)
	--equip
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(100341051,0))
	e4:SetCategory(CATEGORY_EQUIP)
	e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCountLimit(1)
	e4:SetTarget(c100341051.eqtg)
	e4:SetOperation(c100341051.eqop)
	c:RegisterEffect(e4)
	--multi attack
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_SINGLE)
	e5:SetCode(EFFECT_EXTRA_ATTACK)
	e5:SetValue(c100341051.atkval)
	c:RegisterEffect(e5)
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_SINGLE)
	e6:SetCode(EFFECT_CANNOT_ATTACK)
	e6:SetCondition(c100341051.atkcon)
	c:RegisterEffect(e6)
end
function c100341051.eqspfilter(c)
	return c:IsFaceup() and c:IsCode(1546123)
end
function c100341051.hspfilter(c,tp,sc)
	return c:IsLevelBelow(10) and c:IsSetCard(0x4093) and c:IsFusionType(TYPE_FUSION)
		and c:IsControler(tp) and c:GetEquipGroup():IsExists(c100341051.eqspfilter,1,nil) and Duel.GetLocationCountFromEx(tp,tp,c,sc)>0 and c:IsCanBeFusionMaterial(sc,SUMMON_TYPE_SPECIAL)
end
function c100341051.hspcon(e,c)
	if c==nil then return true end
	return Duel.CheckReleaseGroup(c:GetControler(),c100341051.hspfilter,1,nil,c:GetControler(),c)
end
function c100341051.hspop(e,tp,eg,ep,ev,re,r,rp,c)
	local g=Duel.SelectReleaseGroup(tp,c100341051.hspfilter,1,1,nil,tp,c)
	c:SetMaterial(g)
	Duel.Release(g,REASON_COST)
end
function c100341051.efilter(e,re)
	return e:GetHandlerPlayer()~=re:GetHandlerPlayer() and re:IsActivated()
end
function c100341051.eqfilter(c,tp)
	return c:IsType(TYPE_MONSTER) and (c:IsControler(tp) or c:IsAbleToChangeControler())
end
function c100341051.eqtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0
		and Duel.IsExistingMatchingCard(c100341051.eqfilter,tp,LOCATION_GRAVE,LOCATION_GRAVE,1,nil,tp) end
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,nil,1,PLAYER_ALL,LOCATION_GRAVE)
	Duel.SetOperationInfo(0,CATEGORY_LEAVE_GRAVE,nil,1,PLAYER_ALL,LOCATION_GRAVE)
end
function c100341051.eqop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not (c:IsFaceup() and c:IsRelateToEffect(e)) then return end
	if Duel.GetLocationCount(tp,LOCATION_SZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c100341051.eqfilter),tp,LOCATION_GRAVE,LOCATION_GRAVE,1,1,nil,tp)
	local tc=g:GetFirst()
	if tc then
		if not Duel.Equip(tp,tc,c) then return end
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_EQUIP_LIMIT)
		e1:SetProperty(EFFECT_FLAG_OWNER_RELATE)
		e1:SetLabelObject(c)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		e1:SetValue(c100341051.eqlimit)
		tc:RegisterEffect(e1)
	end
end
function c100341051.eqlimit(e,c)
	return c==e:GetLabelObject()
end
function c100341051.atkval(e,c)
	return e:GetHandler():GetEquipCount()-1
end
function c100341051.atkcon(e)
	return e:GetHandler():GetEquipCount()==0
end