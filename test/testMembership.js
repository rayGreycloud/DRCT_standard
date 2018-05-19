var Membership = artifacts.require("Membership");

contract('Membership', function(accounts) {
    let membership;

    it('Setup contract for testing', async function () {
        membership = await Membership.new({from: accounts[3]});
    });

    it("Should assign memberhipType and memberId", async function () {
        await membership.setFee(5, {from: accounts[3]});
        await membership.requestMembership({value: web3.toWei(5,'ether'), from: accounts[0]});
        assert(await membership.getMembershipType(accounts[0]) > 0, "MembershipType should not be zero");
    });

    it("Should assign membership details to new address", async function () {
        await membership.updateMemberAddress(accounts[0], accounts[1], {from: accounts[3]});
        assert(await membership.getMembershipType(accounts[0]) == 0, "MembershipType should be zero");
        assert(await membership.getMembershipType(accounts[1]) > 0, "MembershipType should not be zero");
    });

    it("Should change fee using setFee from owner account", async function () {
        await membership.setFee(15, {from: accounts[3]});
        assert(membership.memberFee = 15, "fee should be 15");
    });

    it("Should change member current membershipType", async function () {
        await membership.setMembershipType(accounts[1],7, {from: accounts[3]});
        assert(await membership.getMembershipType(accounts[1]) == 7, "MembershipType should be 7");
    });

    it("Should get members accounts list/array", async function () {
        let memAccts = await membership.getMembers({from: accounts[4]});
        assert(await memAccts == accounts[1], "Members accounts list");
    });


/** it("Should get member information", async function () {
        await membership.getMember(accounts[1],{from: accounts[6]});
        console.log("membership.getMember- info for member 1");
        assert(membership.members.memberId == 2 && membership.members.membershipType == 7, "Membership should be 1 and id 2");
        console.log("Membership count should be 1");
    });
*/

    it("Should count number of members", async function () {
        let memCount = await membership.countMembers({from: accounts[4]});
        assert(await memCount == 1, "Membership count should be 1");
    });

/*how to*/
/*  it("Should get membershipType", async function () {
        let oldMemberAcct = await membership.getMembershipType(accounts[0], {from: accounts[1]});
        let newMemberAcct = await membership.getMembershipType(accounts[1], {from: accounts[1]});
        console.log("updateMemberAddress");
        assert(oldMemberAcct  == 0, "MembershipType should be zero");
        assert(newMemberAcct == 7, "MembershipType should be 7");
        console.log("ensure member type is greater than zero");
    });
 */
    it("Should allow owner to change contract owner", async function () {
        await membership.setOwner(accounts[5], {from: accounts[3]});
        assert(membership.owner = accounts[5], "owner should be account 5");
    });

})