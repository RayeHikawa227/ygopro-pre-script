--クリビー
--Script by REIKAI
function c100278002.initial_effect(c)
	--to_hand Tri_O
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(100278002,1))
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_BATTLE_DESTROYED)
	e1:SetCountLimit(1,100278002)
	e1:SetTarget(c100278002.thtg)
	e1:SetOperation(c100278002.thop)
	c:RegisterEffect(e1) 
	local e2=e1:Clone()
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCondition(c100278002.thcon)
	c:RegisterEffect(e2)
	--negate attack
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(100278002,2))
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCode(EVENT_ATTACK_ANNOUNCE)
	e3:SetCountLimit(1)
	e3:SetCondition(c100278002.negcon)
	e3:SetOperation(c100278002.negop)
	c:RegisterEffect(e3)
end
function c100278002.thfilter(c)
	return aux.IsCodeListed(c,40640057) and c:IsAbleToHand() and c:IsType(TYPE_SPELL+TYPE_TRAP)
end
function c100278002.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c100278002.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c100278002.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c100278002.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,tp,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
function c100278002.cfilter(c,tp)
	return c:IsPreviousControler(tp) and c:IsPreviousSetCard(0xa4)
end
function c100278002.thcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c100278002.cfilter,1,nil,tp)
end
function c100278002.atfilter(c)
	return c:IsSetCard(0xa4) and c:IsFaceup() and c:IsAttackAbove(1)
end
function c100278002.negcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()~=tp and Duel.IsExistingMatchingCard(c100278002.atfilter,tp,LOCATION_MZONE,0,1,e:GetHandler())
end
function c100278002.negop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c100278002.atfilter,tp,LOCATION_MZONE,0,e:GetHandler())
	for tc in aux.Next(g) do
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_SET_ATTACK_FINAL)
		e1:SetValue(0)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e1)
	end
	Duel.NegateAttack()
end