package models;

import java.net.URL;
import java.util.ArrayList;
import java.util.Collections;
import java.util.Comparator;
import java.util.Date;
import java.util.HashMap;
import java.util.Iterator;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

import javax.persistence.CascadeType;
import javax.persistence.Entity;
import javax.persistence.FetchType;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.ManyToOne;
import javax.persistence.OneToOne;
import javax.persistence.Transient;

import com.fasterxml.jackson.annotation.JsonBackReference;
import com.fasterxml.jackson.annotation.JsonManagedReference;
import models.Pfp.PfpType;
import models.security.User;

import org.apache.commons.collections.CollectionUtils;
import org.apache.commons.lang.NumberUtils;
import org.apache.commons.lang.ObjectUtils;
import org.apache.commons.lang.builder.ToStringBuilder;
import org.apache.commons.lang3.StringUtils;

import play.data.format.Formats;
import play.data.validation.Constraints;
import play.data.validation.Constraints.MaxLength;
import play.data.validation.Constraints.Pattern;
import play.db.ebean.Model;
import play.mvc.PathBindable;
import base.utils.DateUtils;
// import scala.collection.generic.BitOperations.Int;
import base.utils.SortUtils;

import com.avaje.ebean.Ebean;
import com.avaje.ebean.Expr;
import com.avaje.ebean.ExpressionList;
import com.avaje.ebean.Page;
import com.avaje.ebean.Query;
import com.avaje.ebean.SqlQuery;
import com.avaje.ebean.SqlRow;
import com.avaje.ebean.annotation.EnumValue;

/**
 * Event entity managed by JPA
 */
@Entity
public class Donation extends Model implements PathBindable<Donation> {
	
	public static final Finder<Long, Donation>	find	= new Finder<Long, Donation>(Long.class, Donation.class);
	
	public static class DonationReconciliation {
		@Constraints.Required
		@Formats.DateTime(pattern = "MM/dd/yyyy")
		public Date	reconcileFrom;
		
		@Constraints.Required
		@Formats.DateTime(pattern = "MM/dd/yyyy")
		public Date	reconcileTo;
	}
	
	@Constraints.Required
	public int				amount;
	
	@Pattern(value = "^[0-9]{3,4}$", message = "cvv.pattern")
	@Transient
	public String			ccCvvCode;
	
	@Formats.DateTime(pattern = "MM/yyyy")
	@Transient
	public Date				ccExpDate;
	
	@Pattern(value = "^[0-9]{13,19}$", message = "credit.pattern")
	@Transient
	public String			ccNum;
	
	@Transient
	public String			ccName;
	
	@Transient
	@Pattern(value = "(\\d{5}([\\-]\\d{4})?)", message = "zip.pattern")
	public String			ccZip;
	
	public String			checkNum;
	
	@MaxLength(value = 4)
	public String			ccDigits;
	
	@Formats.DateTime(pattern = "MM/dd/yyyy")
	public Date				dateCreated;
	
	@Formats.DateTime(pattern = "MM/dd/yyyy")
	public Date				datePaid;
	
	public String			donorMessage;
	
	public String			donorName;
	
	public DonationType		donationType;
	
	@Transient
	public int				donationTotal;
	
	@Transient
	public int				donationCount;
	
	@Constraints.Required
	@Constraints.Email
	public String			email;
	
	@ManyToOne(optional = false, cascade = CascadeType.REFRESH, fetch = FetchType.LAZY)
	// @JoinColumn(name="eventId")
	@JsonBackReference
	public Event			event;
	
	public String			firstName;
	
	@Id
	@GeneratedValue(strategy = GenerationType.AUTO)
	public Long				id;
	
	public String			lastName;
	
	public boolean			payByCheck;
	
	@ManyToOne(optional = true, cascade = CascadeType.REFRESH, fetch = FetchType.LAZY)
	// @JoinColumn(name="pfpId")
	@JsonBackReference
	public Pfp				pfp;



	@Constraints.Required

	@Pattern(value = "^[0-9]{3}-[0-9]{3}-[0-9]{4}$", message = "phone.pattern")
	@MaxLength(value = 12)
	public String			phone;
	//===============for image and web=================start==================================//

	/*public URL             imgUrl;*/

	/*public String           webUrl;*/
	//===============for image and web=================end==================================//
	
	public PaymentStatus	status;
	
	public PaymentType		paymentType;
	
	public String			transactionNumber;
	
	public String			invoiceNumber;
	
	@Pattern(value = "(\\d{5}([\\-]\\d{4})?)", message = "zip.pattern")
	public String			zipCode;

	/*****************For Img URL*****************/

	public URL imgUrl;

	public String           webUrl;
	
	@OneToOne(mappedBy = "donation", optional = true)
	@JsonManagedReference
	public SponsorItem		sponsorItem;
	
	@Override
	public String toString() {
		return ToStringBuilder.reflectionToString(this);
	}






	//========start======rimi donation of event logic=========30.07.2015================================//
	public static boolean findDuplicateDonationToSameDonor(Long pfpId, String donorName, Long eventId ){
		System.out.println("within findDuplicateDonationToSameDonor....eventId :: "+eventId);
		return find.where().eq("pfp_id",pfpId).eq("donor_name",donorName).eq("event_id",eventId).select("id").findRowCount() > 0;
		//return find.where().eq("id", id).select("id, heroImgUrl, eventEnd, eventStart, slug, status, schoolId, fundraisingEnd, fundraisingStart, goal, name, userAdmin, generalFund").fetch("userAdmin").fetch("generalFund").findUnique();
	}
	//========end======rimi donation of event logic=========30.07.2015================================//











	public static boolean existsByEventId(Long eventId) {
		return find.where().eq("eventId", eventId).select("id").findRowCount() > 0;
	}
	
	public static boolean existsByPfpId(Long pfpId) {
		return find.where().eq("pfp.id", pfpId).select("id").findRowCount() > 0;
	}
	
	public static boolean existsByTransactionNumber(String transactionNumber) {
		return find.where().eq("transactionNumber", transactionNumber).select("id").findRowCount() > 0;
	}
	
	public static Donation findByTransactionNumber(String transactionNumber) {
		return find.where().eq("transactionNumber", transactionNumber).findUnique();
	}
	
	public static List<Donation> findAllByEventId(Long id) {
		final ExpressionList<Donation> donations = find.where().eq("event.id", id);
		if (donations != null) {
			return donations.findList();
		}
		return new ArrayList<Donation>();
	}
	
	public static List<Donation> findAllByEventIdMin(Long id) {
		final Query<Donation> donations = find.where().eq("event.id", id)
						.select("id, firstName, lastName, zipCode, email, phone, donationType, datePaid, paymentType, status, amount, event.name, pfp.name, donation.pfp.team.name, transactionNumber")
						.fetch("pfp").fetch("event");
		if (donations != null) {
			return donations.findList();
		}
		return new ArrayList<Donation>();
	}
	
	public static List<Donation> findAllByEventIdAndCleared(Long id) {
		final Query<Donation> donations = find.where().eq("event.id", id).eq("status", "2")
						.select("id, firstName, lastName, zipCode, email, phone, donationType, datePaid, paymentType, status, amount, event.name, pfp.name, donation.pfp.team.name, transactionNumber")
						.fetch("pfp").fetch("event");
		if (donations != null) {
			return donations.findList();
		}
		return new ArrayList<Donation>();
	}

	//// findDonationPaymentCleared Added by  Suvadeep Datta

	public static List<Donation> findDonationPaymentCleared(Long id) {

		final Query<Donation> donationCleared = find.where().eq("status", "2").eq("event.id", id)
				                          .select("id, firstName, lastName, zipCode, email, phone, donationType, datePaid, paymentType, status, amount, event.name, pfp.name, donation.pfp.team.name, transactionNumber");
		if (donationCleared != null) {
			return donationCleared.findList();
		}
		return new ArrayList<Donation>();
	}
	
	public static List<Donation> findAllByEventIdAndDateRange(Long id, Date from, Date to) {
		final Query<Donation> donations = find.where().eq("event.id", id).gt("dateCreated", from)
						.le("dateCreated", to)
						.select("id, firstName, lastName, zipCode, email, phone, donationType, datePaid, paymentType, status, amount, event.name, pfp.name, donation.pfp.team.name, transactionNumber")
						.fetch("pfp").fetch("event");
		if (donations != null) {
			return donations.findList();
		}
		return new ArrayList<Donation>();
	}
	
	public static List<Donation> findAllByEventIdAndDateRangeAndPaymentType(Long id, Date from, Date to,
					String paymentType) {
		if (StringUtils.isEmpty(paymentType)) {
			return Donation.findAllByEventIdAndDateRange(id, from, to);
		}
		final Query<Donation> donations = find.where().eq("event.id", id).eq("paymentType", paymentType)
						.gt("dateCreated", from).le("dateCreated", to)
						.select("id, firstName, lastName, zipCode, email, phone, donationType, datePaid, paymentType, status, amount, event.name, pfp.name, donation.pfp.team.name, transactionNumber")
						.fetch("pfp").fetch("event");
		if (donations != null) {
			return donations.findList();
		}
		return new ArrayList<Donation>();
	}
	
	public static List<Donation> findAllByEventIdAndClearedAndPaymentType(Long id, String paymentType) {
		if (StringUtils.isEmpty(paymentType)) {
			return Donation.findAllByEventIdAndCleared(id);
		}
		final Query<Donation> donations = find.where().eq("event.id", id).eq("paymentType", paymentType)
						.eq("status", "2")
						.select("id, firstName, lastName, zipCode, email, phone, donationType, datePaid, paymentType, status, amount, event.name, pfp.name, donation.pfp.team.name, transactionNumber")
						.fetch("pfp").fetch("event");
		if (donations != null) {
			return donations.findList();
		}
		return new ArrayList<Donation>();
	}
	
	public static List<Donation> findAllByEventIdAndPaymentType(Long id, String paymentType) {
		if (StringUtils.isEmpty(paymentType)) {
			return Donation.findAllByEventIdMin(id);
		}
		final Query<Donation> donations = find.where()
						.eq("event.id", id).eq("paymentType", paymentType)
						.select("id, firstName, lastName, zipCode, email, phone, donationType, datePaid, paymentType, status, amount, event.name, pfp.name, donation.pfp.team.name, transactionNumber")
						.fetch("pfp").fetch("event");
		if (donations != null) {
			return donations.findList();
		}
		return new ArrayList<Donation>();
	}
	
	public static List<Donation> findAllByEventIdAndOptions(Long id, Map<String, String> options) {
		final ExpressionList<Donation> donations = find.where()
						.eq("event.id", id);
						if(options.containsKey("paymentType") && StringUtils.isNotEmpty(options.get("paymentType"))) {
							donations.eq("paymentType", options.get("paymentType"));	
						}
						if(options.containsKey("status") && StringUtils.isNotEmpty(options.get("status"))) {
							donations.eq("status", options.get("status"));	
						}
						if(options.containsKey("fromDate")) {
							donations.gt("dateCreated", DateUtils.parseDate(options.get("fromDate")).get());	
						}
						if(options.containsKey("toDate")) {
							donations.lt("dateCreated", DateUtils.parseDate(options.get("toDate")).get());	
						}
		final Query<Donation> queryDonations = donations.select("id, firstName, lastName, zipCode, email, phone, donationType, dateCreated, datePaid, paymentType, status, amount, event.name, pfp.id, pfp.name, pfp.team.name, transactionNumber")
						.fetch("pfp").fetch("event");
		if(StringUtils.isEmpty(options.get("totalByPfp"))) {
			queryDonations.orderBy("pfp.id");
		}
		if (queryDonations != null) {
			return queryDonations.findList();
		}
		return new ArrayList<Donation>();
	}
	
	public static List<Donation> findByEventAndTeamId(Long id, Long teamId) {
		final ExpressionList<Donation> donations = find.where().eq("event.id", id).eq("pfp.team.id", teamId)
						.or(Expr.eq("status", "2"), Expr.eq("status", "0"));
		if (donations != null) {
			return donations.findList();
		}
		return new ArrayList<Donation>();
	}
	
	public static List<Donation> findByEventId(Long id) {
		final ExpressionList<Donation> donations = find.where().eq("event.id", id)
						.or(Expr.eq("status", "2"), Expr.eq("status", "0"));
		if (donations != null) {
			return donations.findList();
		}
		return new ArrayList<Donation>();
	}
	
	public static List<Donation> findByEventExceptSponsor(Event event) {
		final ExpressionList<Donation> donations = find.where().eq("event.id", event.id)
						.or(Expr.eq("status", "2"), Expr.eq("status", "0")).ne("donationType", "3");
		if (donations != null) {
			return donations.findList();
		}
		return new ArrayList<Donation>();
	}
	
	public static List<Donation.DonationsByPfp> findByEventExceptSponsorMinPfp(Long eventId) {
		List<Donation.DonationsByPfp> donations = new ArrayList<Donation.DonationsByPfp>();
		String sql = "SELECT donation.pfp_id, pfp.name, donation.amount, donation.private_account from donation, pfp where donation.pfp_id = pfp.id and donation.donation_type != 3 and (donation.status = 0 or donation.status = 2) and donation.event_id = :eventId order by donation.pfp_id";
		
		SqlQuery sqlQuery = Ebean.createSqlQuery(sql);
		sqlQuery.setParameter("eventId", eventId);
		
		// execute the query returning a List of MapBean objects
		List<SqlRow> list = sqlQuery.findList();
		if (CollectionUtils.isNotEmpty(list)) {
			for (SqlRow row : list) {
				Donation.DonationsByPfp donationByPfp = new Donation.DonationsByPfp();
				donationByPfp.amount = row.getInteger("amount");
				donationByPfp.id = row.getLong("pfp_id");
				donationByPfp.name = row.getString("pfp.name");
				donationByPfp.isPrivate = row.getBoolean("pfp.name");
				donations.add(donationByPfp);
			}
		}
		if (donations == null) {
			return new ArrayList<Donation.DonationsByPfp>();
		}
		return donations;
	}
	
	public static List<Donation.DonationTotals> findByEventExceptSponsorTotals(Long eventId) {
		List<Donation.DonationTotals> donations = new ArrayList<Donation.DonationTotals>();
		String sql = "SELECT donation.pfp_id, pfp.name as pfp_name, pfp.private_acct, donation.id as donation_id, team.id as team_id, team.name as team_name, donation.amount from donation, pfp, team where donation.pfp_id = pfp.id and donation.donation_type != 3 and (donation.status = 0 or donation.status = 2) and donation.event_id = :eventId and pfp.team_id = team.id order by team.id;";
		
		SqlQuery sqlQuery = Ebean.createSqlQuery(sql);
		sqlQuery.setParameter("eventId", eventId);
		
		// execute the query returning a List of MapBean objects
		List<SqlRow> list = sqlQuery.findList();
		if (CollectionUtils.isNotEmpty(list)) {
			for (SqlRow row : list) {
				Donation.DonationTotals donationByPfp = new Donation.DonationTotals();
				donationByPfp.amount = row.getInteger("amount");
				donationByPfp.pfpId = row.getLong("pfp_id");
				donationByPfp.pfpName = row.getString("pfp_name");
				donationByPfp.teamId = row.getLong("team_id");
				donationByPfp.teamName = row.getString("team_name");
				donationByPfp.donationId = row.getLong("donation_id");
				donationByPfp.isPrivate = row.getBoolean("private_acct");
				donations.add(donationByPfp);
			}
		}
		if (donations == null) {
			return new ArrayList<Donation.DonationTotals>();
		}
		return donations;
	}
	
	public static List<Donation.DonationsByTeam> findByEventExceptSponsorMinTeam(Long eventId) {
		List<Donation.DonationsByTeam> donations = new ArrayList<Donation.DonationsByTeam>();
		String sql = "SELECT team.id, team.name, donation.amount from donation, pfp, team where donation.pfp_id = pfp.id and donation.donation_type != 3 and (donation.status = 0 or donation.status = 2) and donation.event_id = :eventId and pfp.team_id = team.id order by donation.pfp_id;";
		
		SqlQuery sqlQuery = Ebean.createSqlQuery(sql);
		sqlQuery.setParameter("eventId", eventId);
		
		// execute the query returning a List of MapBean objects
		List<SqlRow> list = sqlQuery.findList();
		if (CollectionUtils.isNotEmpty(list)) {
			for (SqlRow row : list) {
				Donation.DonationsByTeam donationByTeam = new Donation.DonationsByTeam();
				donationByTeam.amount = row.getInteger("amount");
				donationByTeam.id = row.getLong("id");
				donationByTeam.name = row.getString("name");
				donations.add(donationByTeam);
			}
		}
		if (donations == null) {
			return new ArrayList<Donation.DonationsByTeam>();
		}
		return donations;
	}
	
	public static class DonationTotals implements Comparable {
		
		public DonationTotals() {
			super();
			// TODO Auto-generated constructor stub
		}
		
		public DonationTotals(int amount, Long pfpId, String pfpName, Long teamId, String teamName, Long donationId,
						boolean isPrivate) {
			super();
			this.amount = amount;
			this.pfpId = pfpId;
			this.pfpName = pfpName;
			this.teamId = teamId;
			this.teamName = teamName;
			this.donationId = donationId;
			this.isPrivate = isPrivate;
		}
		
		public int		amount;
		public Long		pfpId;
		public String	pfpName;
		public Long		teamId;
		public String	teamName;
		public Long		donationId;
		public boolean	isPrivate;
		
		@Override
		public int compareTo(Object arg0) {
			return this.pfpName.compareTo(((DonationTotals) arg0).pfpName);
		}
	}
	
	public static class DonationsByPfp implements Comparable {
		
		public DonationsByPfp(int amount, Long id, String name, boolean isPrivate) {
			super();
			this.amount = amount;
			this.id = id;
			this.name = name;
			this.isPrivate = isPrivate;
		}
		
		public DonationsByPfp(DonationTotals totals) {
			super();
			this.amount = totals.amount;
			this.id = totals.pfpId;
			this.name = totals.pfpName;
			this.isPrivate = totals.isPrivate;
		}
		
		public DonationsByPfp() {
			super();
			// TODO Auto-generated constructor stub
		}
		
		public int		amount;
		public Long		id;
		public String	name;
		public boolean	isPrivate;
		
		@Override
		public int compareTo(Object arg0) {
			return this.name.compareTo(((DonationsByPfp) arg0).name);
		}

		//=========delete===========start=========//

		//=========delete============end==========//
	}
	
	public static class DonationsByTeam implements Comparable {
		
		public DonationsByTeam(int amount, Long teamId, String name) {
			super();
			this.amount = amount;
			this.id = teamId;
			this.name = name;
		}
		
		public DonationsByTeam(DonationTotals totals) {
			super();
			this.amount = totals.amount;
			this.id = totals.teamId;
			this.name = totals.teamName;
		}
		
		public DonationsByTeam() {
			super();
			// TODO Auto-generated constructor stub
		}
		
		public int		amount;
		public Long		id;
		public String	name;
		
		@Override
		public int compareTo(Object arg0) {
			return this.name.compareTo(((DonationsByTeam) arg0).name);
		}
	}
	
	public static List<Donation> findByEventIdAnonTotal(Long id) {
		final ExpressionList<Donation> donations = find.where().eq("event.id", id).eq("pfp", null)
						.or(Expr.eq("status", "2"), Expr.eq("status", "0"));
		if (donations != null) {
			return donations.findList();
		}
		return new ArrayList<Donation>();
	}
	
	public static List<Donation> findByFromAndToDate(Date from, Date to) {
		final ExpressionList<Donation> donations = find.where().gt("dateCreated", from).le("dateCreated", to)
						.eq("paymentType", "1").eq("status", "0");
		if (donations != null) {
			return donations.findList();
		}
		return new ArrayList<Donation>();
	}
	
	public static Donation findById(Long id) {
		return find.byId(id);
	}
	
	public static Donation findByIdWithMin(Long id) {
		return find.where().eq("id", id).select("id, amount, donorName, pfp.id, pfp.name, transactionNumber, ccDigits, paymentType, status, event.id, event.name, invoiceNumber").fetch("pfp").fetch("event").findUnique();
	}
	
	public static List<Donation> findByPfpId(Long id) {
		final ExpressionList<Donation> donations = find.where().eq("pfp.id", id)
						.or(Expr.eq("status", "2"), Expr.eq("status", "0"));
		if (donations != null) {
			return donations.findList();
		}
		return new ArrayList<Donation>();
	}
	
	public static int getTotalAnonDonations(Long id) {
		return getTotalDonations(findByEventIdAnonTotal(id));
	}
	
	public static int getTotalDonations(List<Donation> donations) {
		int total = 0;
		for (final Donation donation : donations) {
			total += donation.amount;
		}
		return total;
	}
	
	public static int getTotalEventDonationsByUserId(Long userId) {
		List<Object> eventIds = (List<Object>) Event.findAllIdsByUserId(userId);
		int total = 0;
		for (Object eventId : eventIds) {
			total = total + getTotalDonations(findByEventId((Long) eventId));
		}
		return total;
	}
	
	public static int getTotalEventDonations(Long id) {
		return getTotalDonations(findByEventId(id));
	}
	
	public static Map<String, Map<Long, ?>> getTotalAdminDonations(Event event) {
		return Donation.getTotalAdminDonations(event, null);
	}
	
	public static Map<String, Map<Long, ?>> getTotalAdminDonations(Event event, Team pfpTeam) {
		final Map<Long, Donation.DonationsByPfp> pfpTotals = new HashMap<Long, Donation.DonationsByPfp>();
		final Map<Long, Donation.DonationsByTeam> teamTotals = new HashMap<Long, Donation.DonationsByTeam>();
		final List<Donation.DonationTotals> donations = findByEventExceptSponsorTotals(event.id);
		for (final Donation.DonationTotals donation : donations) {
			if(pfpTeam == null || (pfpTeam != null && ObjectUtils.compare(pfpTeam.id, donation.teamId) == 0)) {
				if (pfpTotals.containsKey(donation.pfpId)) {
					pfpTotals.get(donation.pfpId).amount = pfpTotals.get(donation.pfpId).amount + donation.amount;
					// pfpTotals.put(donation.pfpId,
					// (pfpTotals.get(donation.pfpId).amount + donation.amount));
				} else {
					pfpTotals.put(donation.pfpId, new Donation.DonationsByPfp(donation));
				}
			}
			if (teamTotals.containsKey(donation.teamId)) {
				teamTotals.get(donation.teamId).amount = teamTotals.get(donation.teamId).amount + donation.amount;
				// teamTotals.put(donation.teamId,
				// (teamTotals.get(donation.teamId).amount + donation.amount));
			} else {
				teamTotals.put(donation.teamId, new Donation.DonationsByTeam(donation));
			}
			
		}
		
		List<Pfp> pfps = null;
		if(pfpTeam == null) {
			pfps =	Pfp.findByEventExceptSponsor(event);
		} else {
			pfps = Pfp.findByEventAndTeamExceptSponsor(event, pfpTeam);
		}
		for (Pfp pfp : pfps) {
			if (!pfpTotals.containsKey(pfp.id)) {
				int amount = 0;
				if(pfp.pfpType == PfpType.GENERAL) {
					amount = Donation.getTotalPfpDonations(pfp.id);
				}
				pfpTotals.put(pfp.id, new Donation.DonationsByPfp(amount, pfp.id, pfp.name, pfp.privateAcct));
			}
		}
		List<Team> teams = Team.findByEventId(event.id);
		for (Team team : teams) {
			if (!teamTotals.containsKey(team.id)) {
				teamTotals.put(team.id, new Donation.DonationsByTeam(0, team.id, team.name));
			}
		}
		Map<String, Map<Long, ?>> allDonations = new HashMap<String, Map<Long, ?>>();
		allDonations.put("pfp", SortUtils.sortDonationsByPfp(pfpTotals));
		allDonations.put("team", SortUtils.sortDonationsByTeam(teamTotals));
		return allDonations;
	}
	
	public static int getTotalPfpDonations(Long id) {
		return getTotalDonations(findByPfpId(id));
	}
	
	public static int getTotalPfpDonationsByUserId(Long userId) {
		List<Object> eventIds = (List<Object>) Pfp.findAllIdsByUserId(userId);
		int total = 0;
		for (Object eventId : eventIds) {
			total = total + getTotalDonations(findByPfpId((Long) eventId));
		}
		return total;
	}
	
	public static Map<Pfp, Integer> getTotalPfpTeamDonations(Long id, Long teamId) {
		final Map<Pfp, Integer> donationsTotal = new HashMap<Pfp, Integer>();
		final List<Donation> donations = findByEventAndTeamId(id, teamId);
		for (final Donation donation : donations) {
			if (donationsTotal.containsKey(donation.pfp)) {
				donationsTotal.put(donation.pfp, (donationsTotal.get(donation.pfp) + donation.amount));
			} else {
				donationsTotal.put(donation.pfp, donation.amount);
			}
			
		}
		List<Pfp> teamPfps = Pfp.findByTeamId(teamId);
		for (Pfp teamPfp : teamPfps) {
			if (!donationsTotal.containsKey(teamPfp)) {
				donationsTotal.put(teamPfp, 0);
			}
		}
		return donationsTotal;
	}
	
	public static Map<Long, Donation.DonationsByTeam> getTotalTeamDonations(Long id) {
		final List<Donation.DonationsByTeam> donations = findByEventExceptSponsorMinTeam(id);
		final Map<Long, Donation.DonationsByTeam> teamTotals = new HashMap<Long, Donation.DonationsByTeam>();
		for (final Donation.DonationsByTeam donation : donations) {
			if (teamTotals.containsKey(donation.id)) {
				teamTotals.get(donation.id).amount = teamTotals.get(donation.id).amount + donation.amount;
			} else {
				teamTotals.put(donation.id, donation);
			}
		}
		List<Team> teams = Team.findByEventId(id);
		for (Team team : teams) {
			if (!teamTotals.containsKey(team.id)) {
				teamTotals.put(team.id, new Donation.DonationsByTeam(0, team.id, team.name));
			}
		}
		return SortUtils.sortDonationsByTeam(teamTotals);
	}
	
	public static int getTotalTeamDonations(Long id, Long teamId) {
		return getTotalDonations(findByEventAndTeamId(id, teamId));
	}
	
	/**
	 * Return a page of computer
	 * 
	 * @param page
	 *            Page to display
	 * @param pageSize
	 *            Number of pfps per page
	 * @param sortBy
	 *            Pfp property used for sorting
	 * @param order
	 *            Sort order (either or asc or desc)
	 * @param filter
	 *            Filter applied on the name column
	 */
	public static Page<Donation> page(int page, int pageSize, String sortBy, String order, String filter) {
		if (pageSize > 20) {
			pageSize = 20;
		}
		return find.where().ilike("firstName", "%" + filter + "%").orderBy(sortBy + " " + order)
						.findPagingList(pageSize).setFetchAhead(false).getPage(page);
	}
	
	public static Page<Donation> page(int page, int pageSize, String sortBy, String order, String filter, String fieldName, User localUser) {
		String queryField = "donorName";
		if (StringUtils.equals("donorName", fieldName)
				|| StringUtils.equals("transactionNumber", fieldName)
				|| StringUtils.equals("ccDigits", fieldName)
				|| StringUtils.equals("schoolId", fieldName)) {
			queryField = fieldName;
		}
		if (StringUtils.equals("pfpName", fieldName) ) {
			queryField = "pfp.name";
		}
		 if (StringUtils.equals("paymentType", fieldName) ) {
				if(StringUtils.equalsIgnoreCase("CREDIT", filter)) {
					filter = "1";
				} else if(StringUtils.equalsIgnoreCase("CHECK", filter)) {
					filter = "2";
				} else {
					filter = "3";
				}
				queryField = fieldName;
			} 
		if (pageSize > 20) {
			pageSize = 20;
		}
		ExpressionList<Donation> query = find.where().ilike(queryField, "%" + filter + "%");
		if(localUser != null) {
			query.eq("event.userAdmin.id", localUser.id);									
		}
		return query.select("id, amount, donorName, pfp.id, pfp.name, transactionNumber, ccDigits, paymentType, status, event.id, event.name, invoiceNumber")
							.fetch("pfp").fetch("event")
							.orderBy(sortBy + " " + order)
							.findPagingList(pageSize).setFetchAhead(false).getPage(page);	
	}
	
	public enum PaymentStatus {
		@EnumValue("0")
		APPROVED(0, "Approved"), @EnumValue("1")
		PENDING(1, "Pending"), @EnumValue("2")
		CLEARED(2, "Cleared"), @EnumValue("3")
		REFUNDED(3, "Refunded");
		
		private static final Map<String, PaymentStatus>	MAP		= new HashMap<String, PaymentStatus>();
		public static final Map<String, String>			VALUES	= new HashMap<String, String>();
		
		static {
			for (PaymentStatus pt : PaymentStatus.values()) {
				VALUES.put(pt.name(), pt.value);
				MAP.put(pt.name(), pt);
			}
		}
		
		public static PaymentStatus get(String name) {
			return MAP.get(name);
		}
		
		public final int	id;
		
		public final String	value;
		
		public int getId() {
			return id;
		}
		
		public String getValue() {
			return value;
		}
		
		PaymentStatus(int id, String value) {
			this.id = id;
			this.value = value;
		}
		
		// @Override
		// public String toString() {
		// return id + "";
		// }
	}
	
	public enum PaymentType {
		@EnumValue("1")
		CREDIT(1, "Credit"), @EnumValue("2")
		CHECK(2, "Check"), @EnumValue("3")
		CASH(3, "Cash");
		
		private static final Map<String, PaymentType>	MAP		= new HashMap<String, PaymentType>();
		public static final Map<String, String>			VALUES	= new HashMap<String, String>();
		
		static {
			for (PaymentType pt : PaymentType.values()) {
				VALUES.put(pt.name(), pt.value);
				MAP.put(pt.name(), pt);
			}
		}
		
		public static PaymentType get(String name) {
			return MAP.get(name);
		}
		
		public final int	id;
		
		public final String	value;
		
		public int getId() {
			return id;
		}
		
		public String getValue() {
			return value;
		}
		
		PaymentType(int id, String value) {
			this.id = id;
			this.value = value;
		}
		
		// @Override
		// public String toString() {
		// return id + "";
		// }
	}
	
	public enum DonationType {
		@EnumValue("1")
		PFP(1, "Pfp"), @EnumValue("2")
		GENERAL(2, "General Fund"), @EnumValue("3")
		SPONSOR(3, "Sponsor Fund");
		
		private static final Map<String, DonationType>	MAP		= new HashMap<String, DonationType>();
		public static final Map<String, String>			VALUES	= new HashMap<String, String>();
		
		static {
			for (DonationType pt : DonationType.values()) {
				VALUES.put(pt.name(), pt.value);
				MAP.put(pt.name(), pt);
			}
		}
		
		public static DonationType get(String name) {
			return MAP.get(name);
		}
		
		public final int	id;
		
		public final String	value;
		
		public int getId() {
			return id;
		}
		
		public String getValue() {
			return value;
		}
		
		DonationType(int id, String value) {
			this.id = id;
			this.value = value;
		}
		
		// @Override
		// public String toString() {
		// return id + "";
		// }
		
	}
	
	@Override
	public Donation bind(String key, String value) {
		Donation donation = Donation.findById(NumberUtils.createLong(value));
		return donation;
	}
	
	@Override
	public String javascriptUnbind() {
		// TODO Auto-generated method stub
		return null;
	}
	
	@Override
	public String unbind(String arg0) {
		return id + "";
	}
	
}